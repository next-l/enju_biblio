class Item < ActiveRecord::Base
  scope :on_shelf, -> { where('shelf_id != 1') }
  scope :on_web, -> { where(shelf_id: 1) }
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
  belongs_to :bookstore
  belongs_to :required_role, class_name: 'Role', foreign_key: 'required_role_id'
  belongs_to :budget_type

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
      return false if checkouts.not_returned.exists?
      true
    else
      true
    end
  end
end

# == Schema Information
#
# Table name: items
#
#  id                      :integer          not null, primary key
#  call_number             :string
#  item_identifier         :string
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  shelf_id                :integer          default(1), not null
#  include_supplements     :boolean          default(FALSE), not null
#  note                    :text
#  url                     :string
#  price                   :integer
#  lock_version            :integer          default(0), not null
#  required_role_id        :integer          default(1), not null
#  required_score          :integer          default(0), not null
#  acquired_at             :datetime
#  bookstore_id            :integer
#  budget_type_id          :integer
#  circulation_status_id   :integer          default(5), not null
#  checkout_type_id        :integer          default(1), not null
#  binding_item_identifier :string
#  binding_call_number     :string
#  binded_at               :datetime
#  manifestation_id        :integer          not null
#
