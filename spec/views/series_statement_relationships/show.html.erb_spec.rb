require 'spec_helper'

describe "series_statement_relationships/show" do
  before(:each) do
    @series_statement_relationship = assign(:series_statement_relationship, stub_model(SeriesStatementRelationship,
      :parent_id => 1,
      :child_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
