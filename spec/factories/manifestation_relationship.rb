FactoryBot.define do
  factory :manifestation_relationship do
    parent_id{FactoryBot.create(:manifestation).id}
    child_id{FactoryBot.create(:manifestation).id}
    association :manifestation_relationship_type
  end
end
