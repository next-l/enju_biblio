FactoryBot.define do
  factory :item do
    sequence(:item_identifier){|n| "item_#{n}"}
    manifestation_id{FactoryBot.create(:manifestation).id}
    association :bookstore
    association :budget_type
    association :shelf
  end
end
