FactoryBot.define do
  factory :create do
    work_id{FactoryBot.create(:manifestation).id}
    agent_id{FactoryBot.create(:agent).id}
    association :create_type
  end
end
