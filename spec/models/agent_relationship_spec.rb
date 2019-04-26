require 'rails_helper'

describe AgentRelationship do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: agent_relationships
#
#  id                         :bigint(8)        not null, primary key
#  parent_id                  :bigint(8)        not null
#  child_id                   :bigint(8)        not null
#  agent_relationship_type_id :bigint(8)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  position                   :integer
#
