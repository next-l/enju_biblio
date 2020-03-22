require 'rails_helper'

RSpec.describe "custom_manifestation_labels/index", type: :view do
  before(:each) do
    assign(:custom_manifestation_labels, [
      CustomManifestationLabel.create!(
        :library_group => LibraryGroup.first,
        :label => "test1"
      ),
      CustomManifestationLabel.create!(
        :library_group => LibraryGroup.first,
        :label => "test2"
      )
    ])
  end

  it "renders a list of custom_manifestation_labels" do
    render
    assert_select "tr>td", :text => LibraryGroup.first.name.to_s, :count => 2
    assert_select "tr>td", :text => "test1".to_s, :count => 1
    assert_select "tr>td", :text => "test2".to_s, :count => 1
  end
end
