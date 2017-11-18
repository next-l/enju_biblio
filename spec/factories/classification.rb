FactoryBot.define do
  factory :classification do |f|
    f.sequence(:category){|n| "classification_#{n}"}
    f.classification_type_id{FactoryBot.create(:classification_type).id}
  end
end
