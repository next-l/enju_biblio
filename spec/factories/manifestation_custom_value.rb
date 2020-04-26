FactoryBot.define do
  factory :manifestation_custom_value do
    association :manifestation_custom_property
    sequence(:value){|n| "value_#{n}"}
  end
end
