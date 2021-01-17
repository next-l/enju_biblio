require 'rails_helper'

describe "owns/show" do
  before(:each) do
    @own = assign(:own, FactoryBot.create(:own))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@own.item.manifestation.original_title}/)
  end
end
