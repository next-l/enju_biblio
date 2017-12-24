FactoryBot.define do
  factory :identifier_type do |f|
    f.sequence(:name){|n| "identifier_type_#{n}"}
  end
end
