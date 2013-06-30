class AgentImportResult < ActiveRecord::Base
  attr_accessible :agent_import_file_id, :agent_id, :user_id, :body
  default_scope :order => 'agent_import_results.id'
  scope :file_id, proc{|file_id| where(:agent_import_file_id => file_id)}
  scope :failed, where(:agent_id => nil)

  belongs_to :agent_import_file
  belongs_to :agent
  belongs_to :user

  validates_presence_of :agent_import_file_id
end

# == Schema Information
#
# Table name: agent_import_results
#
#  id                    :integer          not null, primary key
#  agent_import_file_id :integer
#  agent_id             :integer
#  user_id               :integer
#  body                  :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

