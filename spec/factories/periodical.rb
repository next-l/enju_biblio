FactoryBot.define do
  factory :periodical do
    sequence(:original_title){|n| "manifestation_title_#{n}"}
    frequency_id { 1 }
  end
end
