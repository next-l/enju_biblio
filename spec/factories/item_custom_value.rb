FactoryBot.define do
  factory :item_custom_value do
    association :item_custom_property
    sequence(:value){|n| "value_#{n}"}
  end
end
