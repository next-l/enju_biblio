# -*- encoding: utf-8 -*-
class ResourceImportFile < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordModel
  include ImportFile
  default_scope {order('resource_import_files.id DESC')}
  scope :not_imported, -> {in_state(:pending)}
  scope :stucked, -> {in_state(:pending).where('created_at < ?', 1.hour.ago)}

  if Setting.uploaded_file.storage == :s3
    has_attached_file :resource_import, :storage => :s3, :s3_credentials => "#{Setting.amazon}",
      :s3_permissions => :private
  else
    has_attached_file :resource_import,
      :path => ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  validates_attachment_content_type :resource_import, :content_type => [
    'text/csv',
    'text/plain',
    'text/tab-separated-values',
    'application/octet-stream',
    'application/vnd.ms-excel'
  ]
  validates_attachment_presence :resource_import
  belongs_to :user, :validate => true
  has_many :resource_import_results
  has_many :resource_import_file_transitions

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
    reload
    num = {:manifestation_imported => 0, :item_imported => 0, :manifestation_found => 0, :item_found => 0, :failed => 0}
    rows = open_import_file
    row_num = 2

    field = rows.first
    if [field['isbn'], field['original_title']].reject{|field| field.to_s.strip == ""}.empty?
      raise "You should specify isbn or original_title in the first line"
    end

    rows.each do |row|
      next if row['dummy'].to_s.strip.present?
      import_result = ResourceImportResult.create!(:resource_import_file_id => self.id, :body => row.fields.join("\t"))

      item_identifier = row['item_identifier'].to_s.strip
      item = Item.where(:item_identifier => item_identifier).first
      if item
        import_result.item = item
        import_result.manifestation = item.manifestation
        import_result.save!
        num[:item_found] += 1
        next
      end

      if row['manifestation_identifier'].present?
        manifestation = Manifestation.where(:manifestation_identifier => row['manifestation_identifier'].to_s.strip).first
      end

      unless manifestation
        if row['doi'].present?
          doi = URI.parse(row['doi']).path.gsub(/^\//, "")
          manifestation = Manifestation.where(:doi => doi).first
        end
      end

      unless manifestation
        if row['jpno'].present?
          jpno = row['jpno'].to_s.strip
          manifestation = Identifier.where(:body => 'jpno', :identifier_type_id => IdentifierType.where(:name => 'jpno').first_or_create.id).first.try(:manifestation)
        end
      end

      unless manifestation
        if row['isbn'].present?
          isbn = StdNum::ISBN.normalize(row['isbn'])
          m = Identifier.where(:body => isbn, :identifier_type_id => IdentifierType.where(:name => 'isbn').first_or_create.id).first.try(:manifestation)
        end
        if m
          if m.series_statements.exists?
            manifestation = m
          end
        end
      end
      num[:manifestation_found] += 1 if manifestation

      if row['original_title'].blank?
        unless manifestation
          begin
            manifestation = Manifestation.import_isbn(isbn) if isbn
            if manifestation
              num[:manifestation_imported] += 1
            end
          rescue EnjuNdl::InvalidIsbn
            manifestation = nil
          rescue EnjuNdl::RecordNotFound
            manifestation = nil
          end
        end
      end

      unless manifestation
        manifestation = fetch(row)
        num[:manifestation_imported] += 1 if manifestation
      end
      import_result.manifestation = manifestation

      if manifestation and item_identifier.present?
        import_result.item = create_item(row, manifestation)
        manifestation.index
      else
        if manifestation.try(:fulltext_content?)
          item = Item.new
          item.circulation_status = CirculationStatus.where(:name => 'Available On Shelf').first
          item.shelf = Shelf.web
          begin
            item.acquired_at = Time.zone.parse(row['acquired_at'].to_s.strip)
          rescue ArgumentError
          end
          item.manifestation_id = manifestation.id
          item.save!
          manifestation.items << item
        end
        num[:failed] += 1
      end

      import_result.save!
      num[:item_imported] +=1 if import_result.item

      row_num += 1
    end

    rows.close
    transition_to!(:completed)
    Rails.cache.write("manifestation_search_total", Manifestation.search.total)
    return num
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def self.import_work(title, agents, options = {:edit_mode => 'create'})
    work = Manifestation.new(title)
    work.save
    work.creators = agents.uniq unless agents.empty?
    work
  end

  def self.import_expression(work, agents, options = {:edit_mode => 'create'})
    expression = work
    expression.save
    expression.contributors = agents.uniq unless agents.empty?
    expression
  end

  def self.import_manifestation(expression, agents, options = {}, edit_options = {:edit_mode => 'create'})
    manifestation = expression
    manifestation.during_import = true
    manifestation.reload
    manifestation.update_attributes!(options)
    manifestation.publishers = agents.uniq unless agents.empty?
    manifestation
  end

  def self.import_item(manifestation, options)
    item = Item.new(options)
    item.shelf = Shelf.web unless item.shelf
    item.manifestation = manifestation
    item
  end

  def import_marc(marc_type)
    file = File.open(self.resource_import.path)
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
      manifestation = Manifestation.new(:original_title => expression.original_title)
      manifestation.carrier_type = CarrierType.find(1)
      manifestation.frequency = Frequency.find(1)
      manifestation.language = Language.find(1)
      manifestation.save

      full_name = record['700']['a']
      publisher = Agent.where(:full_name => record['700']['a']).first
      unless publisher
        publisher = Agent.new(:full_name => full_name)
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
    rows = open_import_file
    row_num = 2

    rows.each do |row|
      item_identifier = row['item_identifier'].to_s.strip
      item = Item.where(:item_identifier => item_identifier).first if item_identifier.present?
      if item
        if item.manifestation
          fetch(row, :edit_mode => 'update')
        end
        shelf = Shelf.where(:name => row['shelf']).first
        circulation_status = CirculationStatus.where(:name => row['circulation_status']).first
        checkout_type = CheckoutType.where(:name => row['checkout_type']).first
        bookstore = Bookstore.where(:name => row['bookstore']).first
        required_role = Role.where(:name => row['required_role']).first
        use_restriction = UseRestriction.where(:name => row['use_restriction'].to_s.strip).first

        item.shelf = shelf if shelf
        item.circulation_status = circulation_status if circulation_status
        item.checkout_type = checkout_type if checkout_type
        item.bookstore = bookstore if bookstore
        item.required_role = required_role if required_role
        item.use_restriction = use_restriction if use_restriction
        item.include_supplements = row['include_supplements'] if row['include_supplements']
        item.call_number = row['call_number'] if row['call_number']
        item.item_price = row['item_price'] if row['item_price']
        item.acquired_at = row['acquired_at'] if row['acquired_at']
        item.note = row['note'] if row['note']
        item.save!
        ExpireFragmentCache.expire_fragment_cache(item.manifestation)
      else
        manifestation_identifier = row['manifestation_identifier'].to_s.strip
        manifestation = Manifestation.where(:manifestation_identifier => manifestation_identifier).first if manifestation_identifier.present?
        unless manifestation
          manifestation = Manifestation.where(:id => row['manifestation_id']).first
        end
        if manifestation
          fetch(row, :edit_mode => 'update')
        end
      end
      row_num += 1
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def remove
    transition_to!(:started)
    rows = open_import_file
    row_num = 2

    rows.each do |row|
      item_identifier = row['item_identifier'].to_s.strip
      item = Item.where(:item_identifier => item_identifier).first
      if item
        item.destroy if item.removable?
      end
      row_num += 1
    end
    transition_to!(:completed)
  rescue => e
    self.error_message = "line #{row_num}: #{e.message}"
    transition_to!(:failed)
    raise e
  end

  def update_relationship
    transition_to!(:started)
    rows = open_import_file
    row_num = 2

    rows.each do |row|
      item_identifier = row['item_identifier'].to_s.strip
      item = Item.where(:item_identifier => item_identifier).first
      unless item
        item = Item.where(:id => row['item_id'].to_s.strip).first
      end

      manifestation_identifier = row['manifestation_identifier'].to_s.strip
      manifestation = Manifestation.where(:manifestation_identifier => manifestation_identifier).first
      unless manifestation
        manifestation = Manifestation.where(:id => row['manifestation_id'].to_s.strip).first
      end

      if item and manifestation
        item.manifestation = manifestation
        item.save!
      end

      import_result = ResourceImportResult.create!(:resource_import_file_id => self.id, :body => row.fields.join("\t"))
      import_result.item = item
      import_result.manifestation = manifestation
      import_result.save!
      row_num += 1
    end
    transition_to!(:completed)
  end

  private
  def open_import_file
    tempfile = Tempfile.new('resource_import_file')
    if Setting.uploaded_file.storage == :s3
      uploaded_file_path = resource_import.expiring_url(10)
    else
      uploaded_file_path = resource_import.path
    end
    open(uploaded_file_path){|f|
      f.each{|line|
        if defined?(CharlockHolmes::EncodingDetector)
          begin
            string = line.encode('UTF-8', CharlockHolmes::EncodingDetector.detect(line)[:encoding], universal_newline: true)
          rescue StandardError
            string = NKF.nkf('-w -Lu', line)
          end
        else
          string = NKF.nkf('-w -Lu', line)
        end
        tempfile.puts(string)
      }
    }
    tempfile.close

    file = CSV.open(tempfile.path, 'r:utf-8', :col_sep => "\t")
    header = file.first
    rows = CSV.open(tempfile.path, 'r:utf-8', :headers => header, :col_sep => "\t")
    ResourceImportResult.create!(:resource_import_file_id => self.id, :body => header.join("\t"))
    tempfile.close(true)
    file.close
    rows
  end

  def import_subject(row)
    subjects = []
    row['subject'].to_s.split('//').each do |s|
      # TODO: Subject typeの設定
      subject = Subject.new(:term => s.to_s.strip)
      subject.subject_type = SubjectType.where(:name => 'concept').first
      subject.subject_heading_type = SubjectHeadingType.where(:name => 'unknown').first
      subjects << subject
    end
    subjects
  end

  def import_classification(row)
    classifications = []
    classification_number = YAML.load(row['classification'].to_s)
    return nil unless classification_number
    classification_number.map{|k, v|
      classification_type = ClassificationType.where(:name => k.downcase).first
      classification = Classification.new(:category => v.to_s)
      classification.classification_type = classification_type
      classification.save!
      classifications << classification
    }
    classifications
  end

  def create_item(row, manifestation)
    shelf = Shelf.where(:name => row['shelf'].to_s.strip).first || Shelf.web
    bookstore = Bookstore.where(:name => row['bookstore'].to_s.strip).first
    budget_type = BudgetType.where(:name => row['budget_type'].to_s.strip).first
    acquired_at = Time.zone.parse(row['acquired_at']) rescue nil
    item = self.class.import_item(manifestation, {
      :manifestation_id => manifestation.id,
      :item_identifier => row['item_identifier'],
      :price => row['item_price'],
      :call_number => row['call_number'].to_s.strip,
      :acquired_at => acquired_at,
    })
    if defined?(EnjuCirculation)
      circulation_status = CirculationStatus.where(:name => row['circulation_status'].to_s.strip).first || CirculationStatus.where(:name => 'In Process').first
      item.circulation_status = circulation_status
      use_restriction = UseRestriction.where(:name => row['use_restriction'].to_s.strip).first
      unless use_restriction
        use_restriction = UseRestriction.where(:name => 'Not For Loan').first
      end
      item.use_restriction = use_restriction
    end
    item.bookstore = bookstore
    item.budget_type = budget_type
    item.shelf = shelf
    item
  end

  def fetch(row, options = {:edit_mode => 'create'})
    shelf = Shelf.where(:name => row['shelf'].to_s.strip).first || Shelf.web
    case options[:edit_mode]
    when 'create'
      manifestation = nil
    when 'update'
      manifestation = Item.where(:item_identifier => row['item_identifier'].to_s.strip).first.try(:manifestation)
      unless manifestation
        manifestation_identifier = row['manifestation_identifier'].to_s.strip
        manifestation = Manifestation.where(:manifestation_identifier => manifestation_identifier).first if manifestation_identifier
        manifestation = Manifestation.where(:id => row['manifestation_id']).first unless manifestation
      end
    end

    title = {}
    title[:original_title] = row['original_title'].to_s.strip
    title[:title_transcription] = row['title_transcription'].to_s.strip
    title[:title_alternative] = row['title_alternative'].to_s.strip
    title[:title_alternative_transcription] = row['title_alternative_transcription'].to_s.strip
    if options[:edit_mode] == 'update'
      title[:original_title] = manifestation.original_title if row['original_title'].to_s.strip.blank?
      title[:title_transcription] = manifestation.title_transcription if row['title_transcription'].to_s.strip.blank?
      title[:title_alternative] = manifestation.title_alternative if row['title_alternative'].to_s.strip.blank?
      title[:title_alternative_transcription] = manifestation.title_alternative_transcription if row['title_alternative_transcription'].to_s.strip.blank?
    end
    #title[:title_transcription_alternative] = row['title_transcription_alternative']
    if title[:original_title].blank? and options[:edit_mode] == 'create'
      return nil
    end

    lisbn = Lisbn.new(row['isbn'].to_s.strip)
    if lisbn.isbn.valid?
      isbn = lisbn.isbn
    end

    # TODO: 小数点以下の表現
    width = NKF.nkf('-eZ1', row['width'].to_s).gsub(/\D/, '').to_i
    height = NKF.nkf('-eZ1', row['height'].to_s).gsub(/\D/, '').to_i
    depth = NKF.nkf('-eZ1', row['depth'].to_s).gsub(/\D/, '').to_i
    end_page = NKF.nkf('-eZ1', row['number_of_pages'].to_s).gsub(/\D/, '').to_i
    language = Language.where(:name => row['language'].to_s.strip.camelize).first
    language = Language.where(:iso_639_2 => row['language'].to_s.strip.downcase).first unless language
    language = Language.where(:iso_639_1 => row['language'].to_s.strip.downcase).first unless language
    
    carrier_type = CarrierType.where(:name => row['carrier_type'].to_s.strip).first

    identifier = {}
    if row['isbn']
      identifier[:isbn] = Identifier.new(:body => row['isbn'])
      identifier[:isbn].identifier_type = IdentifierType.where(:name => 'isbn').first_or_create
    end
    if row['jpno']
      identifier[:jpno] = Identifier.new(:body => row['jpno'])
      identifier[:jpno].identifier_type = IdentifierType.where(:name => 'jpno').first_or_create
    end
    if row['issn']
      identifier[:issn] = Identifier.new(:body => row['issn'])
      identifier[:issn].identifier_type = IdentifierType.where(:name => 'issn').first_or_create
    end

    if end_page >= 1
      start_page = 1
    else
      start_page = nil
      end_page = nil
    end

    if row['fulltext_content'].to_s.downcase.strip == "t"
      fulltext_content = true
    end

    if row['periodical'].to_s.downcase.strip == "t"
      periodical = true
    end

    creators = row['creator'].to_s.split('//')
    creator_transcriptions = row['creator_transcription'].to_s.split('//')
    creators_list = creators.zip(creator_transcriptions).map{|f,t| {:full_name => f.to_s.strip, :full_name_transcription => t.to_s.strip}}
    contributors = row['contributor'].to_s.split('//')
    contributor_transcriptions = row['contributor_transcription'].to_s.split('//')
    contributors_list = contributors.zip(contributor_transcriptions).map{|f,t| {:full_name => f.to_s.strip, :full_name_transcription => t.to_s.strip}}
    publishers = row['publisher'].to_s.split('//')
    publisher_transcriptions = row['publisher_transcription'].to_s.split('//')
    publishers_list = publishers.zip(publisher_transcriptions).map{|f,t| {:full_name => f.to_s.strip, :full_name_transcription => t.to_s.strip}}
    ResourceImportFile.transaction do
      creator_agents = Agent.import_agents(creators_list)
      contributor_agents = Agent.import_agents(contributors_list)
      publisher_agents = Agent.import_agents(publishers_list)
      subjects = import_subject(row) if defined?(EnjuSubject)
      case options[:edit_mode]
      when 'create'
        work = self.class.import_work(title, creator_agents, options)
        if defined?(EnjuSubject)
          work.subjects = subjects.uniq unless subjects.empty?
        end
        expression = self.class.import_expression(work, contributor_agents)
      when 'update'
        expression = manifestation
        work = expression
        work.creators = creator_agents.uniq unless creator_agents.empty?
        expression.contributors = contributor_agents.uniq unless contributor_agents.empty?
        if defined?(EnjuSubject)
          work.subjects = subjects.uniq unless subjects.empty?
        end
      end
      if row['volume_number'].present?
        volume_number = row['volume_number'].to_s.tr('０-９', '0-9').to_i
      end

      attributes = {
        :original_title => title[:original_title],
        :title_transcription => title[:title_transcription],
        :title_alternative => title[:title_alternative],
        :title_alternative_transcription => title[:title_alternative_transcription],
        :pub_date => row['pub_date'],
        :volume_number_string => row['volume_number_string'].to_s.split('　').first.try(:tr, '０-９', '0-9'),
        :issue_number_string => row['issue_number_string'],
        :serial_number => row['serial_number'],
        :edition => row['edition'],
        :edition_string => row['edition_string'],
        :width => width,
        :depth => depth,
        :height => height,
        :price => row['manifestation_price'],
        :description => row['description'],
        #:description_transcription => row['description_transcription'],
        :note => row['note'],
        :statement_of_responsibility => row['statement_of_responsibility'],
        :start_page => start_page,
        :end_page => end_page,
        :access_address => row['access_address'],
        :manifestation_identifier => row['manifestation_identifier'],
        :fulltext_content => fulltext_content
      }.delete_if{|key, value| value.nil?}
      manifestation = self.class.import_manifestation(expression, publisher_agents, attributes,
      {
        :edit_mode => options[:edit_mode]
      })
      manifestation.volume_number = volume_number if volume_number

      required_role = Role.where(:name => row['required_role_name'].to_s.strip.camelize).first
      if required_role and row['required_role_name'].present?
        manifestation.required_role = required_role
      else
        manifestation.required_role = Role.where(:name => 'Guest').first unless manifestation.required_role
      end

      if language and row['language'].present?
        manifestation.language = language
      else
        manifestation.language = Language.where(:name => 'unknown').first unless manifestation.language
      end

      manifestation.carrier_type = carrier_type if carrier_type

      Manifestation.transaction do
        manifestation.identifiers.delete_all if manifestation.identifiers.exists?
        identifier.each do |k, v|
          manifestation.identifiers << v if v.valid?
        end
      end

      if row['series_original_title'].to_s.strip.present?
        Manifestation.transaction do
          if manifestation.series_statements.exists?
            manifestation.series_statements.delete_all
          end
          series_title = row['series_original_title'].split('//')
          series_title_transcription = row['series_title_transcription'].split('//')
          series_statement = SeriesStatement.new(
            :original_title => series_title[0],
            :title_transcription => series_title_transcription[0],
            :title_subseries => "#{series_title[1]} #{series_title[2]}",
            :title_subseries_transcription => "#{series_title_transcription[1]} #{series_title_transcription[2]}",
            :volume_number_string => series_title[0],
            :creator_string => row['series_creator_string'],
          )
          series_statement.manifestation = manifestation
          series_statement.save!
        end
      end

      if defined?(EnjuSubject)
        classifications = import_classification(row)
        if classifications.present?
          manifestation.classifications << classifications
        end
      end

      manifestation.save!

      if options[:edit_mode] == 'create'
        manifestation.set_agent_role_type(creators_list)
        manifestation.set_agent_role_type(contributors_list, :scope => :contributor)
        manifestation.set_agent_role_type(publishers_list, :scope => :publisher)
      end
    end
    manifestation
  end

  def self.transition_class
    ResourceImportFileTransition
  end
end

# == Schema Information
#
# Table name: resource_import_files
#
#  id                           :integer          not null, primary key
#  parent_id                    :integer
#  content_type                 :string(255)
#  size                         :integer
#  user_id                      :integer
#  note                         :text
#  executed_at                  :datetime
#  resource_import_file_name    :string(255)
#  resource_import_content_type :string(255)
#  resource_import_file_size    :integer
#  resource_import_updated_at   :datetime
#  created_at                   :datetime
#  updated_at                   :datetime
#  edit_mode                    :string(255)
#  resource_import_fingerprint  :string(255)
#  error_message                :text
#
