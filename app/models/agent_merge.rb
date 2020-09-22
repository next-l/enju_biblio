class AgentMerge < ApplicationRecord
  belongs_to :agent
  belongs_to :agent_merge_list
  validates :agent, :agent_merge_list, presence: true
  validates_associated :agent, :agent_merge_list

  paginates_per 10
end

# == Schema Information
#
# Table name: agent_merges
#
#  id                  :bigint           not null, primary key
#  agent_id            :integer          not null
#  agent_merge_list_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
