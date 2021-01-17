FactoryBot.define do
  factory :realize do
    expression_id{FactoryBot.create(:manifestation).id}
    agent_id{FactoryBot.create(:agent).id}
  end
end
