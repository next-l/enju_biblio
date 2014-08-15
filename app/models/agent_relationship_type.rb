class AgentRelationshipType < ActiveRecord::Base
  attr_accessible :name, :display_name, :note
  include MasterModel
  default_scope order: 'agent_relationship_types.position'
  has_many :agent_relationships
end

# == Schema Information
#
# Table name: agent_relationship_types
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  display_name :text
#  note         :text
#  position     :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

