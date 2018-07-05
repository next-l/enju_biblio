FactoryBot.define do
  factory :manifestation_relationship_type do
    sequence(:name){|n| "manifestation_relationship_type_#{n}"}
  end
end
