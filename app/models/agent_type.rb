class AgentType < ApplicationRecord
  include MasterModel
  translates :display_name
  has_many :agents
end

# == Schema Information
#
# Table name: agent_types
#
#  id                        :bigint           not null, primary key
#  name                      :string           not null
#  display_name              :text
#  note                      :text
#  position                  :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  display_name_translations :jsonb            not null
#
