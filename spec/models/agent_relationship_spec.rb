require 'rails_helper'

describe AgentRelationship do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: agent_relationships
#
#  id                         :integer          not null, primary key
#  parent_id                  :bigint           not null
#  child_id                   :integer          not null
#  agent_relationship_type_id :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  position                   :integer
#
