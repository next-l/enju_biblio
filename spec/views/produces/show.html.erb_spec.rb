require 'rails_helper'

describe "produces/show" do
  before(:each) do
    @produce = assign(:produce, stub_model(Produce,
      :manifestation_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
      :agent_id => '727eae50-90a8-419b-ab0c-bd8f9a3a2873'
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Manifestation.find('1ff5b88a-1964-4db0-acb3-ae1d9e3a307e').original_title}/)
  end
end
