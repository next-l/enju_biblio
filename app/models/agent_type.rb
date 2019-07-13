class AgentType < ActiveRecord::Base
  include MasterModel
  default_scope { order('agent_types.position') }
  translates :display_name
  has_many :agents
end

# == Schema Information
#
# Table name: agent_types
#
#  id                        :integer          not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime
#  updated_at                :datetime
#  display_name_translations :jsonb            not null
#
