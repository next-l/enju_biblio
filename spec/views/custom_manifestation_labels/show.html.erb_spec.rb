require 'rails_helper'

RSpec.describe "custom_manifestation_labels/show", type: :view do
  before(:each) do
    @custom_manifestation_label = assign(:custom_manifestation_label, CustomManifestationLabel.create!(
      :library_group => LibraryGroup.first,
      :label => "test"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
