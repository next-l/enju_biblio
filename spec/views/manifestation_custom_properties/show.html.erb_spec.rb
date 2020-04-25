require 'rails_helper'

RSpec.describe "manifestation_custom_properties/show", type: :view do
  before(:each) do
    @manifestation_custom_property = assign(:manifestation_custom_property, ManifestationCustomProperty.create!(
      name: "Name",
      note: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
