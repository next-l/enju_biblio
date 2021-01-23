FactoryBot.define do
  factory :agent do
    sequence(:full_name){|n| "full_name_#{n}"}
    agent_type_id{AgentType.find_by(name: 'person').id}
    country_id{Country.first.id}
    language_id{Language.first.id}
  end

  trait :with_librarian_required do
    after(:build) do |agent|
      agent.required_role = Role.find_by(name: 'Librarian')
    end
  end
end

FactoryBot.define do
  factory :invalid_agent, class: Agent do
  end
end
