require 'rails_helper'

describe "manifestations/show.ttl.ruby" do
  fixtures :all

  before(:each) do
    @manifestation = FactoryBot.create(:manifestation)
    assign(:manifestation, @manifestation)
  end

  it "renders info" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(@manifestation.original_title)
  end
end
