# -*- encoding: utf-8 -*-
class Manifestation < ActiveRecord::Base
  enju_circulation_manifestation_model if defined?(EnjuCirculation)
  enju_subject_manifestation_model if defined?(EnjuSubject)
  enju_manifestation_viewer if defined?(EnjuManifestationViewer)
  enju_ndl_ndl_search if defined?(EnjuNdl)
  enju_loc_search if defined?(EnjuLoc)
  enju_nii_cinii_books if defined?(EnjuNii)
  enju_export if defined?(EnjuExport)
  enju_oai if defined?(EnjuOai)
  enju_question_manifestation_model if defined?(EnjuQuestion)
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
  has_one :root_series_statement, foreign_key: 'root_manifestation_id', class_name: 'SeriesStatement'
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
        root_series_statement.root_manifestation.items.pluck(:item_identifier, :binding_item_identifier)
      else
        items.pluck(:item_identifier, :binding_item_identifier)
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
      identifier_contents(:isbn).map{|i|
        [Lisbn.new(i).isbn10, Lisbn.new(i).isbn13]
      }.flatten
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
        root_series_statement.root_manifestation.items.pluck(:item_identifier, :binding_item_identifier)
      else
        items.pluck(:item_identifier, :binding_item_identifier)
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
      identifier_contents(:isbn).map{|i|
        [Lisbn.new(i).isbn10, Lisbn.new(i).isbn13]
      }.flatten
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

  attachment :attachment

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
  validates :issue_number, numericality: {greater_than: 0}, allow_blank: true
  validates :volume_number, numericality: {greater_than: 0}, allow_blank: true
  validates :serial_number, numericality: {greater_than: 0}, allow_blank: true
  validates :edition, numericality: {greater_than: 0}, allow_blank: true
  before_create :set_fingerprint, if: Proc.new{|model| model.attachment}
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
    return nil unless attachment
    client = Faraday.new(url: ENV['SOLR_URL'] || Sunspot.config.solr.url) do |conn|
      conn.request :multipart
      conn.adapter :net_http
      conn.proxy ENV['SOLR_PROXY_URL'].to_s
    end
    response = client.post('update/extract?extractOnly=true&wt=json&extractFormat=text') do |req|
      req.headers['Content-type'] = 'text/html'
      req.body = attachment.read
    end
    update_column(:fulltext, JSON.parse(response.body)[""])
  end

  def extract_text!
    extract_text
    index!
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
    identifiers.identifier_type_scope(name).order(:position).pluck(:body)
  end

  def self.export(options = {format: :txt})
    header = %w(
      manifestation_id
      original_title
      creator
      publisher
      pub_date
      manifestation_price
      isbn
      issn
      item_identifier
      call_number
      item_price
      acquired_at
      accepted_at
      bookstore
      budget_type
      circulation_status
      shelf
      library
    )
    lines = []
    lines << header
    Manifestation.includes(:items, :identifiers => :identifier_type).find_each do |m|
      if m.items.exists?
        m.items.includes(:shelf => :library).each do |i|
          item_lines = []
          item_lines << m.id
          item_lines << m.original_title
          item_lines << m.creators.pluck(:full_name).join("//")
          item_lines << m.publishers.pluck(:full_name).join("//")
          item_lines << m.pub_date
          item_lines << m.price
          item_lines << m.created_at
          item_lines << m.updated_at
          identifiers.each do |identifier_type|
            item_lines << m.identifier_contents(identifier_type.to_sym).first
          end
          item_lines << i.item_identifier
          item_lines << i.call_number
          item_lines << i.price
          item_lines << i.acquired_at
          item_lines << i.accept.try(:created_at)
          item_lines << i.bookstore.try(:name)
          item_lines << i.budget_type.try(:name)
          item_lines << i.circulation_status.try(:name)
          item_lines << i.shelf.name
          item_lines << i.shelf.library.name
          item_lines << i.created_at
          item_lines << i.updated_at
          lines << item_lines
        end
      else
        line = []
        line << m.id
        line << m.original_title
        line << m.creators.pluck(:full_name).join("//")
        line << m.publishers.pluck(:full_name).join("//")
        line << m.pub_date
        line << m.price
        line << m.created_at
        line << m.updated_at
        identifiers.each do |identifier_type|
          line << m.identifier_contents(identifier_type.to_sym).first
        end
        lines << line
      end
    end
    if options[:format] == :txt
      lines.map{|i| i.join("\t")}.join("\r\n")
    else
      lines
    end
  end

  def set_fingerprint
    self.attachment_fingerprint = Digest::SHA1.file(attachment.download.path).hexdigest
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
#  attachment_filename             :string
#  attachment_content_type         :string
#  attachment_size                 :integer
#  attachment_updated_at           :datetime
#  nii_type_id                     :integer
#  title_alternative_transcription :text
#  description                     :text
#  abstract                        :text
#  available_at                    :datetime
#  valid_until                     :datetime
#  date_submitted                  :datetime
#  date_accepted                   :datetime
#  date_caputured                  :datetime
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
#  attachment_id                   :string
#  attachment_fingerprint          :string
#
