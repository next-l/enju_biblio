require 'rails_helper'

describe "realizes/show" do
  before(:each) do
    @realize = assign(:realize, stub_model(Realize,
      :expression_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
      :agent_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Manifestation.find('1ff5b88a-1964-4db0-acb3-ae1d9e3a307e').original_title}/)
  end
end
