require 'rails_helper'

RSpec.describe "manifestation_custom_properties/index", type: :view do
  before(:each) do
    assign(:manifestation_custom_properties, [
      ManifestationCustomProperty.create!(
        name: "Name1",
        note: "MyText"
      ),
      ManifestationCustomProperty.create!(
        name: "Name2",
        note: "MyText"
      )
    ])
  end

  it "renders a list of manifestation_custom_properties" do
    render
    assert_select "tr>td", text: "Name1".to_s, count: 1
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
