FactoryBot.define do
  factory :custom_property do
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :manifestation_custom_property, class: CustomProperty do
    association :resource, factory: :manifestation
    association :custom_label, factory: :custom_manifestation_label
    sequence(:value){|n| "カスタム項目 #{n}"}
  end

  factory :item_custom_property, class: CustomProperty do
    association :resource, factory: :item
    association :custom_label, factory: :custom_item_label
    sequence(:value){|n| "カスタム項目 #{n}"}
  end
end
