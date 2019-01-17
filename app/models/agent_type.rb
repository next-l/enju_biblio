class AgentType < ActiveRecord::Base
  include MasterModel
  include Mobility
  translates :display_name
  default_scope { order('agent_types.position') }
  has_many :agents
end

# == Schema Information
#
# Table name: agent_types
#
#  id           :bigint(8)        not null, primary key
#  name         :string           not null
#  display_name :jsonb            not null
#  note         :text
#  position     :integer          default(1), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
