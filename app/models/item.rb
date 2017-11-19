class Item < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  scope :on_shelf, -> { joins(:shelf).where.not('shelves.name = ?', 'web') }
  scope :on_web, -> { joins(:shelf).where('shelves.name = ?', 'web') }
  scope :available_for, -> user {
    unless user.try(:has_role?, 'Librarian')
      on_shelf
    end
  }
  delegate :display_name, to: :shelf, prefix: true
  has_many :owns
  has_many :agents, through: :owns
  has_many :donates
  has_many :donors, through: :donates, source: :agent
  has_one :resource_import_result
  belongs_to :manifestation, touch: true
  belongs_to :bookstore, optional: true
  belongs_to :required_role, class_name: 'Role', foreign_key: 'required_role_id'
  belongs_to :budget_type, optional: true
  has_many :item_transitions

  def state_machine
    IitemStateMachine.new(self, transition_class: ItemTransition)
  end

  delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
    to: :state_machine

  validates_associated :bookstore
  validates :manifestation_id, presence: true
  validates :item_identifier, allow_blank: true, uniqueness: true,
    format: {with: /\A[0-9A-Za-z_]+\Z/}
  validates :binding_item_identifier, allow_blank: true,
    format: {with: /\A[0-9A-Za-z_]+\Z/}
  validates :url, url: true, allow_blank: true, length: { maximum: 255 }
  validates_date :acquired_at, allow_blank: true

  strip_attributes only: [:item_identifier, :binding_item_identifier,
    :call_number, :binding_call_number, :url]

  searchable do
    text :item_identifier, :note, :title, :creator, :contributor, :publisher,
      :binding_item_identifier
    string :item_identifier, multiple: true do
      [item_identifier, binding_item_identifier]
    end
    integer :required_role_id
    integer :manifestation_id
    integer :shelf_id
    integer :agent_ids, multiple: true
    time :created_at
    time :updated_at
    time :acquired_at
  end

  after_save do
    manifestation.index
    Sunspot.commit
  end
  after_destroy do
    manifestation.index
    Sunspot.commit
  end

  attr_accessor :library_id

  paginates_per 10

  def title
    manifestation.try(:original_title)
  end

  def creator
    manifestation.try(:creator)
  end

  def contributor
    manifestation.try(:contributor)
  end

  def publisher
    manifestation.try(:publisher)
  end

  def owned(agent)
    owns.where(agent_id: agent.id).first
  end

  def manifestation_url
    Addressable::URI.parse("#{LibraryGroup.site_config.url}manifestations/#{self.manifestation.id}").normalize.to_s if self.manifestation
  end

  def removable?
    if defined?(EnjuCirculation)
      return false if circulation_status.name == 'Removed'
      return false if checkouts.exists?
      true
    else
      true
    end
  end

  def self.csv_header(options = {col_sep: "\t"})
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
      item_price
      acquired_at
      accepted_at
      bookstore
      budget_type
      circulation_status
      shelf
      library
      item_created_at
      item_updated_at
    )

    header.to_csv(options)
  end

  def to_export
    row = {
      manifestation_id: manifestation_id,
      title: manifestation.original_title,
      creators: manifestation.creators.pluck(:full_name).join('//'),
      contributors: manifestation.contributors.pluck(:full_name).join('//'),
      publishers: manifestation.publishers.pluck(:full_name).join('//'),
      pub_date: manifestation.pub_date,
      statement_of_responsibility: manifestation.statement_of_responsibility,
      manifestation_price: manifestation.price,
      manifestation_created_at: manifestation.created_at,
      manifestation_updated_at: manifestation.updated_at,
      manifestation_identifier: manifestation.manifestation_identifier,
      access_address: manifestation.access_address,
      manifestation_note: manifestation.note,
      isbn: isbn_records.pluck(:body).join('//'),
      issn: issn_records.pluck(:body).join('//'),
      id: id,
      item_identifier: item_identifier,
      call_number: call_number,
      price: price,
      acquired_at: acquired_at,
      accepted_at: accept.try(:created_at),
      bookstore: bookstore.try(:name),
      budget_type: budget_type.try(:name),
      circulation_status: circulation_status.try(:name),
      shelf: shelf.name,
      library: shelf.library.name,
      created_at: created_at,
      updated_at: updated_at
    }
    if defined?(EnjuSubject)
      row[:subject] = manifestation.subjects.map{|subject| "#{subject.subject_heading_type.name}:#{subject.term}"}.join('//')
      row[:classification] = manifestation.classifications.map{|classification| "#{classification.classification_type.name}:#{classification.category}"}.join('//')
    end
  end

  def to_csv
    to_export.map{|k, v| v}.to_csv(col_sep: "\t")
  end

  def self.export(options = {format: :txt})
    file = ''
    file += Manifestation.csv_header(col_sep: "\t") if options[:format].to_sym == :txt
    Manifestation.find_each do |manifestation|
      file += manifestation.to_csv(options)
    end
    file
  end
end

# == Schema Information
#
# Table name: items
#
#  id                      :uuid             not null, primary key
#  manifestation_id        :uuid             not null
#  call_number             :string
#  item_identifier         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  include_supplements     :boolean          default(FALSE), not null
#  note                    :text
#  url                     :string
#  price                   :integer
#  lock_version            :integer          default(0), not null
#  required_role_id        :integer          default(1), not null
#  acquired_at             :datetime
#  bookstore_id            :integer
#  budget_type_id          :integer
#  circulation_status_id   :integer          default(1), not null
#  checkout_type_id        :integer          default(1), not null
#  binding_item_identifier :string
#  binding_call_number     :string
#  binded_at               :datetime
#  shelf_id                :uuid             not null
#
