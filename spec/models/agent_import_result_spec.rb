require 'rails_helper'

describe AgentImportResult do
  # pending "add some examples to (or delete) #{__FILE__}"

end

# == Schema Information
#
# Table name: agent_import_results
#
#  id                   :uuid             not null, primary key
#  agent_import_file_id :uuid             not null
#  agent_id             :uuid
#  body                 :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
