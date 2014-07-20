# -*- encoding: utf-8 -*-
class Item < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  enju_library_item_model if defined?(EnjuLibrary)
  enju_circulation_item_model if defined?(EnjuCirculation)
  enju_export if defined?(EnjuExport)
  enju_question_item_model if defined?(EnjuQuestion)
  enju_inventory_item_model if defined?(EnjuInventory)
  enju_inter_library_loan_item_model if defined?(EnjuInterLibraryLoan)
  scope :on_shelf, -> {where('shelf_id != 1')}
  scope :on_web, -> {where(:shelf_id => 1)}
  belongs_to :manifestation, touch: true
  has_many :owns
  has_many :agents, :through => :owns
  delegate :display_name, :to => :shelf, :prefix => true
  belongs_to :bookstore, :validate => true
  #has_many :donates
  #has_many :donors, :through => :donates, :source => :agent
  belongs_to :required_role, :class_name => 'Role', :foreign_key => 'required_role_id', :validate => true
  has_one :resource_import_result
  belongs_to :budget_type
  #before_save :create_manifestation

  validates_associated :bookstore
  validates :manifestation_id, :presence => true #, :on => :create
  validates :item_identifier, :allow_blank => true, :uniqueness => true,
    :format => {:with => /\A[0-9A-Za-z_]+\Z/}
  validates :url, :url => true, :allow_blank => true, :length => {:maximum => 255}
  validates_date :acquired_at, :allow_blank => true

  normalize_attributes :item_identifier

  index_name "#{name.downcase.pluralize}-#{Rails.env}"

  after_commit on: :create do
    index_document
  end

  after_commit on: :update do
    update_document
  end

  after_commit on: :destroy do
    delete_document
  end

  settings do
    mappings dynamic: 'false', _routing: {required: true, path: :required_role_id} do
      indexes :item_identifier
      indexes :note
      indexes :title
      indexes :creator
      indexes :contributor
      indexes :publisher
      indexes :manifestation_id, type: 'integer'
      indexes :shelf_id, type: 'integer'
      indexes :created_at
      indexes :updated_at
      indexes :acquired_at
      indexes :agent_ids
    end
  end

  def as_indexed_json(options={})
    as_json.merge(
      title: title,
      creator: creator,
      contributor: contributor,
      publisher: publisher,
      manifestation_id: manifestation.try(:id),
      agent_ids: agent_ids
    )
  end

  attr_accessor :library_id #, :manifestation_id

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
    owns.where(:agent_id => agent.id).first
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

  def create_manifestation
    if manifestation_id
      self.manifestation = Manifestation.find(manifestation_id)
    end
  end
end

# == Schema Information
#
# Table name: items
#
#  id                      :integer          not null, primary key
#  manifestation_id        :integer
#  call_number             :string(255)
#  item_identifier         :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  deleted_at              :datetime
#  shelf_id                :integer          default(1), not null
#  include_supplements     :boolean          default(FALSE), not null
#  note                    :text
#  url                     :string(255)
#  price                   :integer
#  lock_version            :integer          default(0), not null
#  required_role_id        :integer          default(1), not null
#  required_score          :integer          default(0), not null
#  acquired_at             :datetime
#  bookstore_id            :integer
#  budget_type_id          :integer
#  circulation_status_id   :integer          default(5), not null
#  checkout_type_id        :integer          default(1), not null
#  binding_item_identifier :string(255)
#  binding_call_number     :string(255)
#  binded_at               :datetime
#
