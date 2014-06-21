require 'spec_helper'

describe "agent_types/new" do
  before(:each) do
    assign(:agent_type, stub_model(AgentType,
      :name => "MyString",
      :display_name => "MyText",
      :note => "MyText",
      :position => 1
    ).as_new_record)
  end

  it "renders new agent_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => agent_types_path, :method => "post" do
      assert_select "input#agent_type_name", :name => "agent_type[name]"
      assert_select "textarea#agent_type_display_name", :name => "agent_type[display_name]"
      assert_select "textarea#agent_type_note", :name => "agent_type[note]"
    end
  end
end
