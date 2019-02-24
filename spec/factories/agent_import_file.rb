FactoryBot.define do
  factory :agent_import_file, class: AgentImportFile do
    association :user
  end
end
