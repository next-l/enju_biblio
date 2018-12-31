require 'rails_helper'

describe "manifestations/show.txt.erb" do
  fixtures :all

  before(:each) do
    assign(:manifestation, FactoryBot.create(:manifestation))
  end

  it "renders info" do
    allow(view).to receive(:policy).and_return double(create?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
