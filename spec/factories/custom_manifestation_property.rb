FactoryBot.define do
  factory :custom_manifestation_property, class: CustomManifestationProperty do
    sequence(:name){|n| "name_#{n}"}
    value { 'Custom property' }
    association(:manifestation)
  end
end
