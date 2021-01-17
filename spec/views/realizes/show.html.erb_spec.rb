require 'rails_helper'

describe "realizes/show" do
  before(:each) do
    @realize = assign(:realize, FactoryBot.create(:realize))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@realize.expression.original_title}/)
  end
end
