FactoryBot.define do
  factory :item_custom_property do
    sequence(:name){|n| "property_name_#{n}"}
    sequence(:display_name){|n| "プロパティ名_#{n}"}
  end
end
