FactoryBot.define do
  factory :agent do
    sequence(:full_name){|n| "full_name_#{n}"}
    agent_type_id{AgentType.find_by(name: 'person').id}
    country_id{Country.first.id}
    language_id{Language.first.id}
  end
end

FactoryBot.define do
  factory :invalid_agent, class: Agent do |f|
  end
end
