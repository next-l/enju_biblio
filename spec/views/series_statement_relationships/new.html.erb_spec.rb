require 'spec_helper'

describe "series_statement_relationships/new" do
  before(:each) do
    assign(:series_statement_relationship, stub_model(SeriesStatementRelationship,
      :parent_id => 1,
      :child_id => 1
    ).as_new_record)
  end

  it "renders new series_statement_relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => series_statement_relationships_path, :method => "post" do
      assert_select "input#series_statement_relationship_parent_id", :name => "series_statement_relationship[parent_id]"
      assert_select "input#series_statement_relationship_child_id", :name => "series_statement_relationship[child_id]"
    end
  end
end
