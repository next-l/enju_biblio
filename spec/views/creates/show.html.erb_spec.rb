require 'rails_helper'

describe "creates/show" do
  before(:each) do
    @create = assign(:create, stub_model(Create,
      :work_id => 1,
      :agent_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
