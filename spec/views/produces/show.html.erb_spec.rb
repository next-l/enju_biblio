require 'rails_helper'

describe "produces/show" do
  before(:each) do
    @produce = assign(:produce, FactoryBot.create(:produce))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@produce.manifestation.original_title}/)
  end
end
