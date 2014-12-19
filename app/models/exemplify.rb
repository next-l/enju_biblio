class Exemplify < ActiveRecord::Base
  #attr_accessible :manifestation_id, :item_id, :position
  belongs_to :manifestation
  belongs_to :item
  #accepts_nested_attributes_for :item

  validates_associated :manifestation, :item
  validates_presence_of :manifestation_id, :item_id
  validates_uniqueness_of :item_id
  after_save :reindex
  after_destroy :reindex

  acts_as_list scope: :manifestation_id

  def reindex
    manifestation.try(:index)
    item.try(:index)
  end
end

# == Schema Information
#
# Table name: exemplifies
#
#  id               :integer          not null, primary key
#  manifestation_id :integer          not null
#  item_id          :integer          not null
#  position         :integer
#  created_at       :datetime
#  updated_at       :datetime
#
