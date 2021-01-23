FactoryBot.define do
  factory :agent_merge do
    agent_merge_list_id{FactoryBot.create(:agent_merge_list).id}
    agent_id{FactoryBot.create(:agent).id}
  end
end
