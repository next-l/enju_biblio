FactoryBot.define do
  factory :carrier_type do |f|
    f.sequence(:name){|n| "carrier_type_#{n}"}
    f.sequence(:display_name_en){|n| "carrier_type_#{n}"}
    f.sequence(:display_name_ja){|n| "carrier_type_#{n}"}
  end
end
