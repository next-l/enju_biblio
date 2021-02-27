require 'rails_helper'

describe "items/show.json.jbuilder" do
  fixtures :all

  before(:each) do
    assign(:item, FactoryBot.create(:item))
  end

  it "renders a template" do
    render
    expect(rendered).to match(/item_identifier/)
    expect(rendered).not_to match(/memo/)
  end
end
