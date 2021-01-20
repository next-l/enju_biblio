require 'rails_helper'

describe "owns/index" do
  before(:each) do
    @item = FactoryBot.create(:item)
    2.times do
      @item.agents << FactoryBot.create(:agent)
    end
    assign(:owns, Own.page(1))
  end

  it "renders a list of owns" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: @item.item_identifier, count: 2
  end
end
