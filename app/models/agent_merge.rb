class AgentMerge < ActiveRecord::Base
  belongs_to :agent, validate: true
  belongs_to :agent_merge_list, validate: true
  validates_presence_of :agent, :agent_merge_list
  validates_associated :agent, :agent_merge_list

  paginates_per 10
end

# == Schema Information
#
# Table name: agent_merges
#
#  id                  :integer          not null, primary key
#  agent_id            :integer          not null
#  agent_merge_list_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

