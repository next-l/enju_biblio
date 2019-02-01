require 'rails_helper'

describe "agent_types/edit" do
  before(:each) do
    @agent_type = assign(:agent_type, stub_model(AgentType,
      name: "MyString",
      display_name: "MyText",
      note: "MyText",
      position: 1
    ))
  end

  it "renders the edit agent_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", action: agent_types_path(@agent_type), method: "post" do
      assert_select "input#agent_type_name", name: "agent_type[name]"
      assert_select "input#agent_type_display_name_en", name: "agent_type[display_name_en]"
      assert_select "textarea#agent_type_note", name: "agent_type[note]"
    end
  end
end
