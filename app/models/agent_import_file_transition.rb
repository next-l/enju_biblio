class AgentImportFileTransition < ActiveRecord::Base
  #include Statesman::Adapters::ActiveRecordTransition

  
  belongs_to :agent_import_file, inverse_of: :agent_import_file_transitions
  #attr_accessible :to_state, :sort_key, :metadata
end

# == Schema Information
#
# Table name: agent_import_file_transitions
#
#  id                   :integer          not null, primary key
#  to_state             :string
#  metadata             :jsonb
#  sort_key             :integer
#  agent_import_file_id :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  most_recent          :boolean
#
