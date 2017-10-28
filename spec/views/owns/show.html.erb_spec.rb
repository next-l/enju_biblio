require 'rails_helper'

describe "owns/show" do
  before(:each) do
    @own = assign(:own, stub_model(Own,
      :item_id => '17eaea41-eacb-4e08-8e0b-70c6e62e3ed3',
      :agent_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
