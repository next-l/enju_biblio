FactoryBot.define do
  factory :series_statement_merge do
    series_statement_merge_list_id{FactoryBot.create(:series_statement_merge_list).id}
    series_statement_id{FactoryBot.create(:series_statement).id}
  end
end
