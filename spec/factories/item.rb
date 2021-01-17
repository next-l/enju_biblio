FactoryBot.define do
  factory :item do
    sequence(:item_identifier){|n| "item_#{n}"}
    manifestation_id{FactoryBot.create(:manifestation).id}
    association :bookstore
    association :budget_type
  end

  trait :with_agent do
    after(:build) do |item|
      item.agents << FactoryBot.build(:agent)
    end
  end
end
