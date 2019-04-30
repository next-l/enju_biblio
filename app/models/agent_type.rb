class AgentType < ActiveRecord::Base
  include MasterModel
  translates :display_name
  default_scope { order('agent_types.position') }
  has_many :agents
end

# == Schema Information
#
# Table name: agent_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name_translations :jsonb            not null
#  note                      :text
#  position                  :integer          default(1), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
