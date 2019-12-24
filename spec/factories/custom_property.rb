FactoryBot.define do
  factory :custom_property do
    sequence(:label){|n| "custom property #{n}"}
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :manifestation_custom_property, class: CustomProperty do
    association :resource, factory: :manifestation
    sequence(:label){|n| "custom property #{n}"}
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :item_custom_property, class: CustomProperty do
    association :resource, factory: :item
    sequence(:label){|n| "custom property #{n}"}
    sequence(:value){|n| "カスタム項目 #{n}"}
  end
end
