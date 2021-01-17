require 'rails_helper'

describe "creates/show" do
  before(:each) do
    @create = assign(:create, FactoryBot.create(:create))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{@create.work.original_title}/)
  end
end
