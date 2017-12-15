require 'rails_helper'

describe "creates/show" do
  before(:each) do
    @create = assign(:create, stub_model(Create,
      :work_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
      :agent_id => '727eae50-90a8-419b-ab0c-bd8f9a3a2873'
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
