class AgentMergeList < ActiveRecord::Base
  attr_accessible :title
  has_many :agent_merges, dependent: :destroy
  has_many :agents, through: :agent_merges
  validates_presence_of :title

  paginates_per 10

  def merge_agents(selected_agent)
    self.agents.each do |agent|
      Create.update_all(['agent_id = ?', selected_agent.id], ['agent_id = ?', agent.id])
      Produce.update_all(['agent_id = ?', selected_agent.id], ['agent_id = ?', agent.id])
      Own.update_all(['agent_id = ?', selected_agent.id], ['agent_id = ?', agent.id])
      Donate.update_all(['agent_id = ?', selected_agent.id], ['agent_id = ?', agent.id])
      agent.destroy unless agent == selected_agent
    end
  end
end

# == Schema Information
#
# Table name: agent_merge_lists
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

