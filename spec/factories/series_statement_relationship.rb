# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :series_statement_relationship do |f|
    f.parent_id{FactoryBot.create(:series_statement).id}
    f.child_id{FactoryBot.create(:series_statement).id}
  end
end
