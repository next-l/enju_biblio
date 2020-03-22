require 'rails_helper'

RSpec.describe "custom_item_labels/show", type: :view do
  before(:each) do
    @custom_item_label = assign(:custom_item_label, CustomItemLabel.create!(
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
