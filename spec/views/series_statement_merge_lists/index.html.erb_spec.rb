require 'rails_helper'

describe "series_statement_merge_lists/index" do
  before(:each) do
    assign(:series_statement_merge_lists, SeriesStatementMergeList.page(1))
  end

  it "renders a list of series_statement_merge_lists" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "test1".to_s, count: 1
  end
end
