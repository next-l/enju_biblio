require 'spec_helper'

describe "manifestations/show" do
  fixtures :all

  before(:each) do
    @manifestation = assign(:manifestation, FactoryGirl.create(:manifestation))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
