require 'spec_helper'

describe "series_statement_relationships/index" do
  before(:each) do
    assign(:series_statement_relationships, [
      stub_model(SeriesStatementRelationship,
        :parent_id => 1,
        :child_id => 2
      ),
      stub_model(SeriesStatementRelationship,
        :parent_id => 1,
        :child_id => 2
      )
    ])
  end

  it "renders a list of series_statement_relationships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "title1", :count => 2
    assert_select "tr>td", :text => "title2", :count => 2
  end
end
