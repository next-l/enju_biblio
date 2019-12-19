FactoryBot.define do
  factory :manifestation_custom_property, class: CustomProperty do
    association :resource, factory: :manifestation
    name { 'test1' }
    value { 'テスト1' }
  end

  factory :item_custom_property, class: CustomProperty do
    association :resource, factory: :item
    name { 'test1' }
    value { 'テスト1' }
  end
end
