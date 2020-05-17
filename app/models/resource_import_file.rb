class ResourceImportFile < ApplicationRecord
  include Statesman::Adapters::ActiveRecordQueries[
    transition_class: ResourceImportFileTransition,
    initial_state: :pending
  ]
  include ImportFile
  scope :not_imported, -> { in_state(:pending) }
  scope :stucked, -> { in_state(:pending).where('resource_import_files.created_at < ?', 1.hour.ago) }

  has_one_attached :attachment
  validates :attachment, presence: true, on: :create
  validates :default_shelf_id, presence: true, if: Proc.new{|model| model.edit_mode == 'create'}
  belongs_to :user
  belongs_to :default_shelf, class_name: 'Shelf', optional: true
  has_many :resource_import_results, dependent: :destroy
  has_many :resource_import_file_transitions, autosave: false, dependent: :destroy

  attr_accessor :mode, :library_id

  def state_machine
    ResourceImportFileStateMachine.new(self, transition_class: ResourceImportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def import_start
    case edit_mode
    when 'destroy'
      remove
    when 'update_relationship'
      update_relationship
    else
      import
    end
  end

  def import
    transition_to!(:started)
    row_num = 1
    result = {
      manifestation_created: 0, manifestation_updated: 0, manifestation_failed: 0, manifestation_found: 0, manifestation_skipped: 0,
      item_created: 0, item_updated: 0, item_failed: 0, item_found: 0, item_skipped: 0,
      circulation_imported: 0, circulation_skipped: 0
    }

    entries = ManifestationImporter.import(create_import_temp_file(attachment), default_shelf: default_shelf&.name, action: edit_mode)
    entries.each do |entry|
      ResourceImportResult.create!(
        resource_import_file: self,
        manifestation: entry.manifestation_record,
        item: entry.item_record,
        error_message: entry.error_message
      )

      case entry.manifestation_result
      when :created
        result[:manifestation_created] += 1
      when :updated
        result[:manifestation_updated] += 1
      when :found
        result[:manifestation_found] += 1
      when :failed
        result[:manifestation_failed] += 1
      when :skipped
        result[:manifestation_skipped] += 1
      end

      case entry.item_result
      when :created
        result[:item_created] += 1
      when :updated
        result[:item_updated] += 1
      when :found
        result[:item_found] += 1
      when :failed
        result[:item_failed] += 1
      when :skipped
        result[:item_skipped] += 1
      end
    end

    if defined?(EnjuCirculation)
      CirculationImporter.import(create_import_temp_file(attachment), action: edit_mode).each do |circulation_entry|
        case circulation_entry.result
        when :imported
          result[:circulation_imported] += 1
        when :skipped
          result[:circulation_skipped] += 1
        end
      end
    end

    Sunspot.commit
    transition_to!(:completed)
    mailer = ResourceImportMailer.completed(self)
    send_message(mailer)
    Rails.cache.write("manifestation_search_total", Manifestation.search.total)
    result
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    mailer = ResourceImportMailer.failed(self)
    send_message(mailer)
    raise e
  end

  def import_marc(marc_type)
    file = attachment.download
    case marc_type
    when 'marcxml'
      reader = MARC::XMLReader.new(file)
    else
      reader = MARC::Reader.new(file)
    end
    file.close

    #when 'marc_xml_url'
    #  url = URI(params[:marc_xml_url])
    #  xml = open(url).read
    #  reader = MARC::XMLReader.new(StringIO.new(xml))
    #end

    # TODO
    for record in reader
      manifestation = Manifestation.new(original_title: expression.original_title)
      manifestation.carrier_type = CarrierType.find(1)
      manifestation.frequency = Frequency.find(1)
      manifestation.language = Language.find(1)
      manifestation.save

      full_name = record['700']['a']
      publisher = Agent.find_by(full_name: record['700']['a'])
      unless publisher
        publisher = Agent.new(full_name: full_name)
        publisher.save
      end
      manifestation.publishers << publisher
    end
  end

  def self.import
    ResourceImportFile.not_imported.each do |file|
      file.import_start
    end
  rescue
    Rails.logger.info "#{Time.zone.now} importing resources failed!"
  end

  #def import_jpmarc
  #  marc = NKF::nkf('-wc', self.db_file.data)
  #  marc.split("\r\n").each do |record|
  #  end
  #end

  def update_relationship
    transition_to!(:started)
    rows = open_import_file(create_import_temp_file(attachment))
    rows.shift
    row_num = 1

    rows.each do |row|
      item_identifier = row['item_identifier'].to_s.strip
      item = Item.find_by(item_identifier: item_identifier)
      unless item
        item = Item.find_by(id: row['item_id'].to_s.strip)
      end

      manifestation_identifier = row['manifestation_identifier'].to_s.strip
      manifestation = Manifestation.find_by(manifestation_identifier: manifestation_identifier)
      unless manifestation
        manifestation = Manifestation.find_by(id: row['manifestation_id'].to_s.strip)
      end

      if item && manifestation
        item.manifestation = manifestation
        item.save!
      end

      import_result = ResourceImportResult.create!(resource_import_file_id: id, body: row.fields.join("\t"))
      import_result.item = item
      import_result.manifestation = manifestation
      import_result.save!
      row_num += 1
    end
    transition_to!(:completed)
    mailer = ResourceImportMailer.completed(self)
    send_message(mailer)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    mailer = ResourceImportMailer.failed(self)
    send_message(mailer)
    raise e
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :bigint           not null, primary key
#  user_id                     :bigint
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :integer
#
