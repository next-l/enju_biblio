require 'rails_helper'

describe SeriesStatementMergeList do
  it "should merge series_statement" do
    series_statement_merge_list = FactoryBot.create(:series_statement_merge_list)
    expect(series_statement_merge_list).to be_valid
  end
end

# == Schema Information
#
# Table name: series_statement_merge_lists
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
