require 'rails_helper'

describe "series_statement_merges/index" do
  fixtures :all

  before(:each) do
    assign(:series_statement_merges, Kaminari.paginate_array([
      stub_model(SeriesStatementMerge,
        series_statement_id: 1,
        series_statement_merge_list_id: 1
      ),
      stub_model(SeriesStatementMerge,
        series_statement_id: 1,
        series_statement_merge_list_id: 2
      )
    ]).page(1))
  end

  it "renders a list of series_statement_merges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td"
  end
end
