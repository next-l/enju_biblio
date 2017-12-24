FactoryBot.define do
  factory :identifier do |f|
    f.sequence(:body){|n| "identifier_body_#{n}"}
    f.identifier_type_id{FactoryBot.create(:identifier_type).id}
  end
end
