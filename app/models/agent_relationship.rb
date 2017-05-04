class AgentRelationship < ActiveRecord::Base
  belongs_to :parent, foreign_key: 'parent_id', class_name: 'Agent'
  belongs_to :child, foreign_key: 'child_id', class_name: 'Agent'
  belongs_to :agent_relationship_type
  validate :check_parent
  validates_presence_of :parent_id, :child_id
  acts_as_list scope: :parent_id

  def check_parent
    errors.add(:parent) if parent_id == child_id
  end
end

# == Schema Information
#
# Table name: agent_relationships
#
#  id                         :integer          not null, primary key
#  parent_id                  :integer
#  child_id                   :integer
#  agent_relationship_type_id :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  position                   :integer
#
