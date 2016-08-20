class Manifestation < ActiveRecord::Base
  enju_manifestation_viewer if defined?(EnjuManifestationViewer)
  enju_ndl_ndl_search if defined?(EnjuNdl)
  enju_loc_search if defined?(EnjuLoc)
  enju_nii_cinii_books if defined?(EnjuNii)
  enju_bookmark_manifestation_model if defined?(EnjuBookmark)

  has_many :creates, dependent: :destroy, foreign_key: 'work_id'
  has_many :creators, through: :creates, source: :agent #, order: 'creates.position'
  has_many :realizes, dependent: :destroy, foreign_key: 'expression_id'
  has_many :contributors, through: :realizes, source: :agent #, order: 'realizes.position'
  has_many :produces, dependent: :destroy, foreign_key: 'manifestation_id'
  has_many :publishers, through: :produces, source: :agent #, order: 'produces.position'
  has_many :items, dependent: :destroy
  has_many :children, foreign_key: 'parent_id', class_name: 'ManifestationRelationship', dependent: :destroy
  has_many :parents, foreign_key: 'child_id', class_name: 'ManifestationRelationship', dependent: :destroy
  has_many :derived_manifestations, through: :children, source: :child
  has_many :original_manifestations, through: :parents, source: :parent
  has_many :picture_files, as: :picture_attachable, dependent: :destroy
  belongs_to :language
  belongs_to :carrier_type
  belongs_to :manifestation_content_type, class_name: 'ContentType', foreign_key: 'content_type_id'
  has_many :series_statements
  belongs_to :frequency
  belongs_to :required_role, class_name: 'Role', foreign_key: 'required_role_id', validate: true
  has_one :resource_import_result
  has_many :identifiers, dependent: :destroy
  accepts_nested_attributes_for :creators, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :contributors, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :publishers, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :series_statements, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :identifiers, allow_destroy: true, reject_if: :all_blank

  searchable do
    text :title, default_boost: 2 do
      titles
    end
    text :fulltext, :note, :creator, :contributor, :publisher, :description,
      :statement_of_responsibility
    text :item_identifier do
      if series_master?
        root_series_statement.root_manifestation.items.pluck(:item_identifier, :binding_item_identifier).flatten.compact
      else
        items.pluck(:item_identifier, :binding_item_identifier).flatten.compact
      end
    end
    string :call_number, multiple: true do
      items.pluck(:call_number)
    end
    string :title, multiple: true
    # text フィールドだと区切りのない文字列の index が上手く作成
    #できなかったので。 downcase することにした。
    #他の string 項目も同様の問題があるので、必要な項目は同様の処置が必要。
    string :connect_title do
      title.join('').gsub(/\s/, '').downcase
    end
    string :connect_creator do
      creator.join('').gsub(/\s/, '').downcase
    end
    string :connect_publisher do
      publisher.join('').gsub(/\s/, '').downcase
    end
    string :isbn, multiple: true do
      isbn_characters
    end
    string :issn, multiple: true do
      if series_statements.exists?
        [identifier_contents(:issn), (series_statements.map{|s| s.manifestation.identifier_contents(:issn)})].flatten.uniq.compact
      else
        identifier_contents(:issn)
      end
    end
    string :lccn, multiple: true do
      identifier_contents(:lccn)
    end
    string :jpno, multiple: true do
      identifier_contents(:jpno)
    end
    string :carrier_type do
      carrier_type.name
    end
    string :library, multiple: true do
      if series_master?
        root_series_statement.root_manifestation.items.map{|i| i.shelf.library.name}.flatten.uniq
      else
        items.map{|i| i.shelf.library.name}
      end
    end
    string :language do
      language.try(:name)
    end
    string :item_identifier, multiple: true do
      if series_master?
        root_series_statement.root_manifestation.items.pluck(:item_identifier, :binding_item_identifier).flatten.compact
      else
        items.pluck(:item_identifier, :binding_item_identifier).flatten.compact
      end
    end
    string :shelf, multiple: true do
      items.collect{|i| "#{i.shelf.library.name}_#{i.shelf.name}"}
    end
    time :created_at
    time :updated_at
    time :deleted_at
    time :pub_date, multiple: true do
      if series_master?
        root_series_statement.root_manifestation.pub_dates
      else
        pub_dates
      end
    end
    time :date_of_publication
    integer :pub_year do
      date_of_publication.try(:year)
    end
    integer :creator_ids, multiple: true
    integer :contributor_ids, multiple: true
    integer :publisher_ids, multiple: true
    integer :item_ids, multiple: true
    integer :original_manifestation_ids, multiple: true
    integer :parent_ids, multiple: true do
      original_manifestations.pluck(:id)
    end
    integer :required_role_id
    integer :height
    integer :width
    integer :depth
    integer :volume_number
    integer :issue_number
    integer :serial_number
    integer :start_page
    integer :end_page
    integer :number_of_pages
    float :price
    integer :series_statement_ids, multiple: true
    boolean :repository_content
    # for OpenURL
    text :aulast do
      creators.pluck(:last_name)
    end
    text :aufirst do
      creators.pluck(:first_name)
    end
    # OTC start
    string :creator, multiple: true do
      creator.map{|au| au.gsub(' ', '')}
    end
    text :au do
      creator
    end
    text :atitle do
      if serial? && root_series_statement.nil?
        titles
      end
    end
    text :btitle do
      title unless serial?
    end
    text :jtitle do
      if serial?
        if root_series_statement
          root_series_statement.titles
        else
          titles
        end
      end
    end
    text :isbn do  # 前方一致検索のためtext指定を追加
      isbn_characters
    end
    text :issn do # 前方一致検索のためtext指定を追加
      if series_statements.exists?
        [identifier_contents(:issn), (series_statements.map{|s| s.manifestation.identifier_contents(:issn)})].flatten.uniq.compact
      else
        identifier_contents(:issn)
      end
    end
    string :sort_title
    string :doi, multiple: true do
      identifier_contents(:doi)
    end
    boolean :serial do
      serial?
    end
    boolean :series_master do
      series_master?
    end
    boolean :resource_master do
      if serial?
        if series_master?
          true
        else
          false
        end
      else
        true
      end
    end
    time :acquired_at
  end

  if ENV['ENJU_STORAGE'] == 's3'
    has_attached_file :attachment, storage: :s3,
      s3_credentials: {
        access_key: ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
        bucket: ENV['S3_BUCKET_NAME'],
        s3_host_name: ENV['S3_HOST_NAME'],
        s3_region: ENV["S3_REGION"]
      },
      s3_permissions: :private
  else
    has_attached_file :attachment,
      path: ":rails_root/private/system/:class/:attachment/:id_partition/:style/:filename"
  end
  do_not_validate_attachment_file_type :attachment

  validates_presence_of :original_title, :carrier_type, :language
  validates_associated :carrier_type, :language
  validates :start_page, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :end_page, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :height, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :width, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :depth, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :manifestation_identifier, uniqueness: true, allow_blank: true
  validates :pub_date, format: {with: /\A\[{0,1}\d+([\/-]\d{0,2}){0,2}\]{0,1}\z/}, allow_blank: true
  validates :access_address, url: true, allow_blank: true, length: {maximum: 255}
  validates :issue_number, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :volume_number, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :serial_number, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  validates :edition, numericality: {greater_than_or_equal_to: 0}, allow_blank: true
  after_create :clear_cached_numdocs
  before_save :set_date_of_publication, :set_number
  after_save :index_series_statement, :extract_text!
  after_destroy :index_series_statement
  after_touch do |manifestation|
    manifestation.index
    manifestation.index_series_statement
    Sunspot.commit
  end
  strip_attributes only: [:manifestation_identifier, :pub_date, :original_title]
  paginates_per 10

  attr_accessor :during_import, :parent_id

  def set_date_of_publication
    return if pub_date.blank?
    year = Time.utc(pub_date.rjust(4, "0")).year rescue nil
    begin
      date = Time.zone.parse(pub_date.rjust(4, "0"))
      if date.year != year
        raise ArgumentError
      end
    rescue ArgumentError, TZInfo::AmbiguousTime
      date = nil
    end

    pub_date_string = pub_date.rjust(4, "0").split(';').first.gsub(/[\[\]]/, '')
    if pub_date_string.length == 4
      date = Time.zone.parse(Time.utc(pub_date_string).to_s).beginning_of_day
    else
      while date.nil? do
        pub_date_string += '-01'
        break if pub_date_string =~ /-01-01-01$/
        begin
          date = Time.zone.parse(pub_date_string)
          if date.year != year
            raise ArgumentError
          end
        rescue ArgumentError
          date = nil
        rescue TZInfo::AmbiguousTime
          date = nil
          self.year_of_publication = pub_date_string.to_i if pub_date_string =~ /^\d+$/
          break
        end
      end
    end

    if date
      self.year_of_publication = date.year
      self.month_of_publication = date.month
      if date.year > 0
        self.date_of_publication = date
      end
    end
  end

  def self.cached_numdocs
    Rails.cache.fetch("manifestation_search_total"){Manifestation.search.total}
  end

  def clear_cached_numdocs
    Rails.cache.delete("manifestation_search_total")
  end

  def parent_of_series
    original_manifestations
  end

  def number_of_pages
    if start_page && end_page
      end_page.to_i - start_page.to_i + 1
    end
  end

  def titles
    title = []
    title << original_title.to_s.strip
    title << title_transcription.to_s.strip
    title << title_alternative.to_s.strip
    title << volume_number_string
    title << issue_number_string
    title << serial_number.to_s
    title << edition_string
    title << series_statements.map{|s| s.titles}
    #title << original_title.wakati
    #title << title_transcription.wakati rescue nil
    #title << title_alternative.wakati rescue nil
    title.flatten
  end

  def url
    #access_address
    "#{LibraryGroup.site_config.url}#{self.class.to_s.tableize}/#{self.id}"
  end

  def creator
    creators.collect(&:name).flatten
  end

  def contributor
    contributors.collect(&:name).flatten
  end

  def publisher
    publishers.collect(&:name).flatten
  end

  def title
    titles
  end

  # TODO: よりよい推薦方法
  def self.pickup(keyword = nil, current_user = nil)
    return nil if self.cached_numdocs < 5
    if current_user.try(:role)
      current_role_id = current_user.role.id
    else
      current_role_id = 1
    end

    # TODO: ヒット件数が0件のキーワードがあるときに指摘する
    response = Manifestation.search do
      fulltext keyword if keyword
      with(:required_role_id).less_than_or_equal_to current_role_id
      order_by(:random)
      paginate page: 1, per_page: 1
    end
    response.results.first
  end

  def extract_text
    return nil if attachment.path.nil?
    return nil unless ENV['ENJU_EXTRACT_TEXT'] == 'true'
    if ENV['ENJU_STORAGE'] == 's3'
      body = Faraday.get(attachment.expiring_url(10)).body.force_encoding('UTF-8')
    else
      body = File.open(attachment.path).read
    end
    client = Faraday.new(url: ENV['SOLR_URL'] || Sunspot.config.solr.url) do |conn|
      conn.request :multipart
      conn.adapter :net_http
    end
    response = client.post('update/extract?extractOnly=true&wt=json&extractFormat=text') do |req|
      req.headers['Content-type'] = 'text/html'
      req.body = body
    end
    update_column(:fulltext, JSON.parse(response.body)[""])
  end

  def extract_text!
    extract_text
    index
    Sunspot.commit
  end

  def created(agent)
    creates.where(agent_id: agent.id).first
  end

  def realized(agent)
    realizes.where(agent_id: agent.id).first
  end

  def produced(agent)
    produces.where(agent_id: agent.id).first
  end

  def sort_title
    if series_master?
      if root_series_statement.title_transcription?
        NKF.nkf('-w --katakana', root_series_statement.title_transcription)
      else
        root_series_statement.original_title
      end
    else
      if title_transcription?
        NKF.nkf('-w --katakana', title_transcription)
      else
        original_title
      end
    end
  end

  def self.find_by_isbn(isbn)
    identifier_type = IdentifierType.where(name: 'isbn').first
    return nil unless identifier_type
    Manifestation.includes(identifiers: :identifier_type).where(:"identifiers.body" => isbn, :"identifier_types.name" => 'isbn')
  end

  def index_series_statement
    series_statements.map{|s| s.index; s.root_manifestation.try(:index)}
  end

  def acquired_at
    items.order(:acquired_at).first.try(:acquired_at)
  end

  def series_master?
    return true if root_series_statement
    false
  end

  def web_item
    items.where(shelf_id: Shelf.web.id).first
  end

  def set_agent_role_type(agent_lists, options = {scope: :creator})
    agent_lists.each do |agent_list|
      name_and_role = agent_list[:full_name].split('||')
      if agent_list[:agent_identifier].present?
        agent = Agent.where(agent_identifier: agent_list[:agent_identifier]).first
      end
      agent = Agent.where(full_name: name_and_role[0]).first unless agent
      next unless agent
      type = name_and_role[1].to_s.strip

      case options[:scope]
      when :creator
        type = 'author' if type.blank?
        role_type = CreateType.where(name: type).first
        create = Create.where(work_id: id, agent_id: agent.id).first
        if create
          create.create_type = role_type
          create.save(validate: false)
        end
      when :publisher
        type = 'publisher' if role_type.blank?
        produce = Produce.where(manifestation_id: id, agent_id: agent.id).first
        if produce
          produce.produce_type = ProduceType.where(name: type).first
          produce.save(validate: false)
        end
      else
        raise "#{options[:scope]} is not supported!"
      end
    end
  end

  def set_number
    self.volume_number = volume_number_string.scan(/\d*/).map{|s| s.to_i if s =~ /\d/}.compact.first if volume_number_string && !volume_number?
    self.issue_number = issue_number_string.scan(/\d*/).map{|s| s.to_i if s =~ /\d/}.compact.first if issue_number_string && !issue_number?
    self.edition = edition_string.scan(/\d*/).map{|s| s.to_i if s =~ /\d/}.compact.first if edition_string && !edition?
  end

  def pub_dates
    return [] unless pub_date
    pub_date_array = pub_date.split(';')
    pub_date_array.map{|pub_date_string|
      date = nil
      while date.nil? do
        pub_date_string += '-01'
        break if pub_date_string =~ /-01-01-01$/
        begin
          date = Time.zone.parse(pub_date_string)
        rescue ArgumentError
        rescue TZInfo::AmbiguousTime
        end
      end
      date
    }.compact
  end

  def latest_issue
    if series_master?
      derived_manifestations.where('date_of_publication IS NOT NULL').order('date_of_publication DESC').first
    end
  end

  def first_issue
    if series_master?
      derived_manifestations.where('date_of_publication IS NOT NULL').order('date_of_publication DESC').first
    end
  end

  def identifier_contents(name)
    if Rails::VERSION::MAJOR > 3
      identifiers.id_type(name).order(:position).pluck(:body)
    else
      identifier_type = IdentifierType.where(name: name).first
      if identifier_type
        identifiers.where(identifier_type_id: identifier_type.id).order(:position).pluck(:body)
      else
        []
      end
    end
  end

  def self.csv_header(role, options = {col_sep: "\t", role: :Guest})
    header = %w(
      manifestation_id
      original_title
      creator
      contributor
      publisher
      pub_date
      statement_of_responsibility
      manifestation_price
      manifestation_created_at
      manifestation_updated_at
      manifestation_identifier
      access_address
      note
    )

    header += IdentifierType.order(:position).pluck(:name)
    if defined?(EnjuSubject)
      header += SubjectHeadingType.order(:position).pluck(:name).map{|type| "subject:#{type}"}
      header += ClassificationType.order(:position).pluck(:name).map{|type| "classification:#{type}"}
    end

    header += %w(
      item_id
      item_identifier
      call_number
    )
    case role.to_sym
    when :Administrator, :Librarian
      header << "item_price"
    end
    header += %w(
      acquired_at
      accepted_at
    )
    case role.to_sym
    when :Administrator, :Librarian
      header += %w(
        bookstore
        budget_type
      )
    end
    header += %w(
      circulation_status
      shelf
      library
      item_created_at
      item_updated_at
    )

    header.to_csv(options)
  end

  def to_csv(options = {format: :txt, role: :Guest})
    lines = []
    if items.exists?
      items.includes(shelf: :library).each do |i|
        item_lines = []
        item_lines << id
        item_lines << original_title
        if creators.exists?
          item_lines << creators.pluck(:full_name).join("//")
        else
          item_lines << nil
        end
        if contributors.exists?
          item_lines << contributors.pluck(:full_name).join("//")
        else
          item_lines << nil
        end
        if publishers.exists?
          item_lines << publishers.pluck(:full_name).join("//")
        else
          item_lines << nil
        end
        item_lines << pub_date
        item_lines << statement_of_responsibility
        item_lines << price
        item_lines << created_at
        item_lines << updated_at
        item_lines << manifestation_identifier
        item_lines << access_address
        item_lines << note

        IdentifierType.order(:position).pluck(:name).each do |identifier_type|
          if identifier_contents(identifier_type.to_sym).first
            item_lines << identifier_contents(identifier_type.to_sym).first
          else
            item_lines << nil
          end
        end
        if defined?(EnjuSubject)
          SubjectHeadingType.order(:position).each do |subject_heading_type|
            if subjects.exists?
              item_lines << subjects.where(subject_heading_type: subject_heading_type).pluck(:term).join('//')
            else
              item_lines << nil
            end
          end
          ClassificationType.order(:position).each do |classification_type|
            if classifications.exists?
              item_lines << classifications.where(classification_type: classification_type).pluck(:category).join('//')
            else
              item_lines << nil
            end
          end
        end

        item_lines << i.id
        item_lines << i.item_identifier
        item_lines << i.call_number
        case options[:role].to_sym
        when :Administrator, :Librarian
          item_lines << i.price
        end
        item_lines << i.acquired_at
        item_lines << i.accept.try(:created_at)
        case options[:role].to_sym
        when :Administrator, :Librarian
          item_lines << i.bookstore.try(:name)
          item_lines << i.budget_type.try(:name)
        end
        item_lines << i.circulation_status.try(:name)
        item_lines << i.shelf.name
        item_lines << i.shelf.library.name
        item_lines << i.created_at
        item_lines << i.updated_at
        lines << item_lines
      end
    else
      line = []
      line << id
      line << original_title
      if creators.exists?
        line << creators.pluck(:full_name).join("//")
      else
        line << nil
      end
      if contributors.exists?
        line << contributors.pluck(:full_name).join("//")
      else
        line << nil
      end
      if publishers.exists?
        line << publishers.pluck(:full_name).join("//")
      else
        line << nil
      end
      line << pub_date
      line << statement_of_responsibility
      line << price
      line << created_at
      line << updated_at
      line << manifestation_identifier
      line << access_address
      line << note

      IdentifierType.order(:position).pluck(:name).each do |identifier_type|
        if identifier_contents(identifier_type.to_sym).first
          line << identifier_contents(identifier_type.to_sym).first
        else
          line << nil
        end
      end
      if defined?(EnjuSubject)
        SubjectHeadingType.order(:position).each do |subject_heading_type|
          if subjects.exists?
            line << subjects.where(subject_heading_type: subject_heading_type).pluck(:term).join('//')
          else
            line << nil
          end
        end
        ClassificationType.order(:position).each do |classification_type|
          if classifications.exists?
            line << classifications.where(classification_type: classification_type).pluck(:category).join('//')
          else
            line << nil
          end
        end
      end

      lines << line
    end

    if options[:format] == :txt
      lines.map{|i| i.to_csv(col_sep: "\t")}.join
    else
      lines
    end
  end

  def self.export(options = {format: :txt, role: :Guest})
    file = ''
    file += Manifestation.csv_header(options[:role], col_sep: "\t") if options[:format].to_sym == :txt
    Manifestation.find_each do |manifestation|
      file += manifestation.to_csv(options)
    end
    file
  end

  def root_series_statement
    series_statements.where(root_manifestation_id: id).first
  end

  def isbn_characters
    identifier_contents(:isbn).map{|i|
      isbn10 = isbn13 = isbn10_dash = isbn13_dash = nil
      isbn10 = Lisbn.new(i).isbn10
      isbn13 =  Lisbn.new(i).isbn13
      isbn10_dash = Lisbn.new(isbn10).isbn_with_dash if isbn10
      isbn13_dash = Lisbn.new(isbn13).isbn_with_dash if isbn13
      [
        isbn10, isbn13, isbn10_dash, isbn13_dash
      ]
    }.flatten
  end
end

# == Schema Information
#
# Table name: manifestations
#
#  id                              :integer          not null, primary key
#  original_title                  :text             not null
#  title_alternative               :text
#  title_transcription             :text
#  classification_number           :string
#  manifestation_identifier        :string
#  date_of_publication             :datetime
#  date_copyrighted                :datetime
#  created_at                      :datetime
#  updated_at                      :datetime
#  deleted_at                      :datetime
#  access_address                  :string
#  language_id                     :integer          default(1), not null
#  carrier_type_id                 :integer          default(1), not null
#  start_page                      :integer
#  end_page                        :integer
#  height                          :integer
#  width                           :integer
#  depth                           :integer
#  price                           :integer
#  fulltext                        :text
#  volume_number_string            :string
#  issue_number_string             :string
#  serial_number_string            :string
#  edition                         :integer
#  note                            :text
#  repository_content              :boolean          default(FALSE), not null
#  lock_version                    :integer          default(0), not null
#  required_role_id                :integer          default(1), not null
#  required_score                  :integer          default(0), not null
#  frequency_id                    :integer          default(1), not null
#  subscription_master             :boolean          default(FALSE), not null
#  attachment_file_name            :string
#  attachment_content_type         :string
#  attachment_file_size            :integer
#  attachment_updated_at           :datetime
#  title_alternative_transcription :text
#  description                     :text
#  abstract                        :text
#  available_at                    :datetime
#  valid_until                     :datetime
#  date_submitted                  :datetime
#  date_accepted                   :datetime
#  date_captured                   :datetime
#  pub_date                        :string
#  edition_string                  :string
#  volume_number                   :integer
#  issue_number                    :integer
#  serial_number                   :integer
#  content_type_id                 :integer          default(1)
#  year_of_publication             :integer
#  attachment_meta                 :text
#  month_of_publication            :integer
#  fulltext_content                :boolean
#  serial                          :boolean
#  statement_of_responsibility     :text
#  publication_place               :text
#  extent                          :text
#  dimensions                      :text
#
