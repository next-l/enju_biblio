FactoryBot.define do
  factory :agent_import_result, class: AgentImportResult do
    association :agent_import_file
    association :agent
  end
end
