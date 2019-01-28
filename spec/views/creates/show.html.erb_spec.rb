require 'rails_helper'

describe "creates/show" do
  fixtures :manifestations, :agents

  before(:each) do
    @create = assign(:create, stub_model(Create,
      work_id: manifestations(:manifestation_00001).id,
      agent_id: agents(:agent_00001).id
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{agents(:agent_00001).id}/)
  end
end
