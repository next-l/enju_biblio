FactoryBot.define do
  factory :agent_merge do |f|
    f.agent_merge_list_id{FactoryBot.create(:agent_merge_list).id}
    f.agent_id{FactoryBot.create(:agent).id}
  end
end
