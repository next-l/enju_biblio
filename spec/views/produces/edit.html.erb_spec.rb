require 'spec_helper'

describe "produces/edit" do
  fixtures :produce_types

  before(:each) do
    @produce = assign(:produce, stub_model(Produce,
      :manifestation_id => 1,
      :agent_id => 1
    ))
    @produce_types = ProduceType.all
  end

  it "renders the edit produce form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => produces_path(@produce), :method => "post" do
      assert_select "input#produce_manifestation_id", :name => "produce[manifestation_id]"
      assert_select "input#produce_agent_id", :name => "produce[agent_id]"
    end
  end
end
