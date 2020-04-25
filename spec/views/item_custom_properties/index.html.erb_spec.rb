require 'rails_helper'

RSpec.describe "item_custom_properties/index", type: :view do
  before(:each) do
    assign(:item_custom_properties, [
      ItemCustomProperty.create!(
        name: "Name1",
        note: "MyText"
      ),
      ItemCustomProperty.create!(
        name: "Name2",
        note: "MyText"
      )
    ])
  end

  it "renders a list of item_custom_properties" do
    render
    assert_select "tr>td", text: "Name1".to_s, count: 1
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
