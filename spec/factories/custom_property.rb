FactoryBot.define do
  factory :manifestation_custom_property, class: CustomProperty do
    association :resource, factory: :manifestation
    sequence(:name){|n| "custom property #{n}"}
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :item_custom_property, class: CustomProperty do
    association :resource, factory: :item
    sequence(:name){|n| "custom property #{n}"}
    sequence(:value){|n| "カスタム項目 #{n}"}
  end
end
