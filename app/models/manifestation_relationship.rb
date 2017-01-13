class ManifestationRelationship < ActiveRecord::Base
  belongs_to :parent, foreign_key: 'parent_id', class_name: 'Manifestation'
  belongs_to :child, foreign_key: 'child_id', class_name: 'Manifestation'
  belongs_to :manifestation_relationship_type
  validate :check_parent
  validates_presence_of :parent_id, :child_id
  acts_as_list scope: :parent_id

  def check_parent
    if parent_id == child_id
      errors.add(:parent)
      errors.add(:child)
    end
  end
end

# == Schema Information
#
# Table name: manifestation_relationships
#
#  id                                 :integer          not null, primary key
#  parent_id                          :uuid
#  child_id                           :uuid
#  manifestation_relationship_type_id :integer
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  position                           :integer
#
