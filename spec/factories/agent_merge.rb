FactoryGirl.define do
  factory :agent_merge do |f|
    f.agent_merge_list_id{FactoryGirl.create(:agent_merge_list).id}
    f.agent_id{FactoryGirl.create(:agent).id}
  end
end
