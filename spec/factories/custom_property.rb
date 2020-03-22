FactoryBot.define do
  factory :custom_property do
    association :custom_label
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :manifestation_custom_property, class: CustomProperty do
    association :custom_label
    association :resource, factory: :manifestation
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :item_custom_property, class: CustomProperty do
    association :custom_label
    association :resource, factory: :item
    sequence(:value){|n| "カスタム項目 #{n}"}
  end
end
