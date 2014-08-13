# -*- encoding: utf-8 -*-
class Item < ActiveRecord::Base
  enju_library_item_model if defined?(EnjuLibrary)
  enju_circulation_item_model if defined?(EnjuCirculation)
  enju_export if defined?(EnjuExport)
  enju_question_item_model if defined?(EnjuQuestion)
  enju_inventory_item_model if defined?(EnjuInventory)
  enju_inter_library_loan_item_model if defined?(EnjuInterLibraryLoan)
  attr_accessible :call_number, :item_identifier, :circulation_status_id,
    :checkout_type_id, :shelf_id, :include_supplements, :note, :url, :price,
    :acquired_at, :bookstore_id, :missing_since, :budget_type_id, :lock_version,
    :manifestation_id, :library_id, :required_role_id,
    :binding_item_identifier, :binding_call_number, :binded_at
  scope :on_shelf, where('shelf_id != 1')
  scope :on_web, where(:shelf_id => 1)
  belongs_to :manifestation, touch: true
  has_many :owns
  has_many :agents, :through => :owns
  delegate :display_name, :to => :shelf, :prefix => true
  belongs_to :bookstore, :validate => true
  has_many :donates
  has_many :donors, :through => :donates, :source => :agent
  belongs_to :required_role, :class_name => 'Role', :foreign_key => 'required_role_id', :validate => true
  has_one :resource_import_result
  belongs_to :budget_type

  validates_associated :bookstore
  validates :manifestation_id, :presence => true
  validates :item_identifier, :allow_blank => true, :uniqueness => true,
    :format => {:with => /\A[0-9A-Za-z_]+\Z/}
  validates :binding_item_identifier, :allow_blank => true,
    :format => {:with => /\A[0-9A-Za-z_]+\Z/}
  validates :url, :url => true, :allow_blank => true, :length => {:maximum => 255}
  validates_date :acquired_at, :allow_blank => true

  normalize_attributes :item_identifier

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
end

# == Schema Information
#
# Table name: items
#
#  id                      :integer          not null, primary key
#  call_number             :string(255)
#  item_identifier         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
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
#  manifestation_id        :integer
#
