class AgentMergeList < ActiveRecord::Base
  has_many :agent_merges, dependent: :destroy
  has_many :agents, through: :agent_merges
  validates_presence_of :title

  paginates_per 10

  def merge_agents(selected_agent)
    self.agents.each do |agent|
      Create.where(agent_id: selected_agent.id).update_all(agent_id: agent.id)
      Produce.where(agent_id: selected_agent.id).update_all(agent_id: agent.id)
      Own.where(agent_id: selected_agent.id).update_all(agent_id: agent.id)
      Donate.where(agent_id: selected_agent.id).update_all(agent_id: agent.id)
      unless agent == selected_agent
        agent.creates.delete_all
        agent.produces.delete_all
        agent.owns.delete_all
        agent.donates.delete_all
        agent.destroy
      end
    end
  end
end

# == Schema Information
#
# Table name: agent_merge_lists
#
#  id         :integer          not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
