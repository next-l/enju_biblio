require 'spec_helper'

describe "owns/show" do
  before(:each) do
    @own = assign(:own, stub_model(Own,
      :item_id => 1,
      :agent_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
