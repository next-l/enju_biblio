class ResourceImportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include ImportFile
  has_one_attached :attachment
  scope :not_imported, -> { in_state(:pending) }
  scope :stucked, -> { in_state(:pending).where('resource_import_files.created_at < ?', 1.hour.ago) }

  validates :default_shelf_id, presence: true, if: Proc.new{|model| model.edit_mode == 'create'}
  belongs_to :user
  belongs_to :default_shelf, class_name: 'Shelf'
  has_many :resource_import_results
  has_many :resource_import_file_transitions

  before_create :set_fingerprint
  attr_accessor :mode, :library_id

  def state_machine
    ResourceImportFileStateMachine.new(self, transition_class: ResourceImportFileTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  def import_start
    case edit_mode
    when 'create'
      import
    when 'update'
      modify
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
    rows = open_import_file(create_import_temp_file(attachment.download))
    rows.shift
    items = []
    manifestations = []
    rows.each do |row|
      next if row['dummy'].to_s.present?
      item = Item.find_by(item_identifier: row['item_identifier'].to_s.strip)
      next if item
      manifestation = nil
      isbn_record = IsbnRecord.find_by(body: row['isbn'])
      if isbn_record
        manifestation = isbn_record.manifestations.first
      end
      manifestation = Manifestation.find_by(manifestation_identifier: row['manifestation_identifier'].to_s.strip) unless manifestation
      manifestation = Manifestation.find_by(id: row['manifestation_id'].to_s.strip) unless manifestation

      language = Language.where(name: row['language'].to_s.strip.camelize).first
      language = Language.where(iso_639_2: row['language'].to_s.strip.downcase).first unless language
      language = Language.where(iso_639_1: row['language'].to_s.strip.downcase).first unless language
			language = Language.find_by(name: 'unknown') unless language

      manifestation = Manifestation.create(
        original_title: row['original_title'],
        carrier_type: CarrierType.find_by(name: row['carrier_type'].to_s.strip) || CarrierType.find(1),
        manifestation_content_type: ContentType.find_by(name: row['content_type'].to_s.strip) || ContentType.find(1),
        frequency: Frequency.find_by(name: row['frequency'].to_s.strip) || Frequency.find(1),
        language: language,
				pub_date: row['pub_date'],
        volume_number: row['volume_number'],
        volume_number_string: row['volume_number_string'],
        issue_number: row['issue_number'],
        issue_number_string: row['issue_number_string'],
        serial_number: row['serial_number'],
        edition: row['edition'],
        edition_string: row['edition_string'],
				price: row['manifestation_price'],
        description: row['description'],
        note: row['note'],
				statement_of_responsibility: row['statement_of_responsibility'],
        access_address: row['access_address'],
				manifestation_identifier: row['manifestation_identifier'],
				publication_place: row['publication_place'],
        extent: row['extent'],
        dimensions: row['dimensions'],
        start_page: row['start_page'],
        end_page: row['end_page'],
      ) unless manifestation

      if manifestation.valid?
        item = Item.new(
          manifestation: manifestation,
          shelf: Shelf.find_by(name: row['shelf'].to_s.strip) || Shelf.first,
          price: row['item_price'],
          call_number: row['call_number'],
          binding_call_number: row['binding_call_number'],
          item_identifier: row['item_identifier'],
          binding_item_identifier: row['binding_item_identifier']
        )
        items << item
      end
    end

    result = Item.import items, on_duplicate_key_ignore: true
    Item.find(result.ids).map{|item| item.index; item.manifestation.index}; Sunspot.commit

    ResourceImportResult.create!(resource_import_file_id: id, body: rows.headers.join("\t"))

    rows.close
    transition_to!(:completed)
    send_message
    Rails.cache.write("manifestation_search_total", Manifestation.search.total)
    result
  #rescue => e
  #  self.error_message = "line #{row_num}: #{e.message}"
  #  save
  #  transition_to!(:failed)
  #  raise e
  end

  def import_marc(marc_type)
    file = File.open(attachment.path)
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
      publisher = Agent.where(full_name: record['700']['a']).first
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

  def modify
    transition_to!(:started)
    rows = open_import_file(create_import_temp_file(attachment.download))
    rows.shift
    row_num = 1

    ResourceImportResult.create!(resource_import_file_id: id, body: rows.headers.join("\t"))
    transition_to!(:completed)
  #rescue => e
  #  self.error_message = "line #{row_num}: #{e.message}"
  #  save
  #  transition_to!(:failed)
  #  raise e
  end

  def remove
    transition_to!(:started)
    rows = open_import_file(create_import_temp_file(attachment.download))
    rows.shift
    row_num = 1

    rows.each do |row|
      row_num += 1
      item_identifier = row['item_identifier'].to_s.strip
      item = Item.find_by(item_identifier: item_identifier)
      if item
        item.checked_items.delete_all
        item.destroy if item.removable?
      end
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    save
    transition_to!(:failed)
    raise e
  end

  private
  def open_import_file(tempfile)
    rows = CSV.open(tempfile, headers: true, col_sep: "\t")
    #ResourceImportResult.create!(resource_import_file_id: id, body: header.join("\t"))
    tempfile.close(true)
    rows
  end

  def import_subject(row)
    subjects = []
    SubjectHeadingType.order(:position).pluck(:name).map{|s| "subject:#{s}"}.each do |column_name|
      type = column_name.split(':').last
      subject_list = row[column_name].to_s.split('//')
      subject_list.map{|value|
        subject_heading_type = SubjectHeadingType.where(name: type).first
        next unless subject_heading_type
        subject = Subject.new(term: value)
        subject.subject_heading_type = subject_heading_type
        # TODO: Subject typeの設定
        subject.subject_type = SubjectType.where(name: 'concept').first
        subject.save!
        subjects << subject
      }
    end
    subjects
  end

  def import_classification(row)
    classifications = []
    ClassificationType.order(:position).pluck(:name).map{|c| "classification:#{c}"}.each do |column_name|
      type = column_name.split(':').last
      classification_list = row[column_name].to_s.split('//')
      classification_list.map{|value|
        classification_type = ClassificationType.where(name: type).first
        next unless classification_type
        classification = Classification.new(category: value)
        classification.classification_type = classification_type
        classification.save!
        classifications << classification
      }
    end
    classifications
  end

  def self.transition_class
    ResourceImportFileTransition
  end

  def self.initial_state
    :pending
  end

  def set_fingerprint
    self.resource_import_fingerprint = Digest::SHA1.file(attachment.download.path).hexdigest
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                          :integer          not null, primary key
#  user_id                     :integer
#  note                        :text
#  executed_at                 :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  edit_mode                   :string
#  resource_import_fingerprint :string
#  error_message               :text
#  user_encoding               :string
#  default_shelf_id            :uuid
#  attachment_data             :jsonb
#
