FactoryBot.define do
  factory :subject do
    sequence(:term){|n| "subject_#{n}"}
    subject_heading_type_id{FactoryBot.create(:subject_heading_type).id}
    subject_type_id{FactoryBot.create(:subject_type).id}
  end
end
