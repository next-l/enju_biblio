class AgentImportFileTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :agent_import_file, inverse_of: :agent_import_file_transitions
end

# == Schema Information
#
# Table name: agent_import_file_transitions
#
#  id                   :integer          not null, primary key
#  to_state             :string(255)
#  metadata             :text             default("{}")
#  sort_key             :integer
#  agent_import_file_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#
