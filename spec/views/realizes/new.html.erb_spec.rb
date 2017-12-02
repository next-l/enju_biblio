require 'rails_helper'

describe "realizes/new" do
  fixtures :realize_types

  before(:each) do
    assign(:realize, stub_model(Realize,
      :expression_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
      :agent_id => '727eae50-90a8-419b-ab0c-bd8f9a3a2873'
    ).as_new_record)
    @realize_types = RealizeType.all
  end

  it "renders new realize form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => realizes_path, :method => "post" do
      assert_select "input#realize_expression_id", :name => "realize[expression_id]"
      assert_select "input#realize_agent_id", :name => "realize[agent_id]"
    end
  end
end
