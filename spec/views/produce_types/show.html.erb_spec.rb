require 'rails_helper'

describe "produce_types/show" do
  fixtures :all
  before(:each) do
    @produce_type = produce_types(:publisher)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
