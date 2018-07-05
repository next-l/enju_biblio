FactoryBot.define do
  factory :agent_relationship do
    parent_id{FactoryBot.create(:agent).id}
    child_id{FactoryBot.create(:agent).id}
    association :agent_relationship_type
  end
end
