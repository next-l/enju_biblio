require 'rails_helper'

RSpec.describe "custom_manifestation_labels/edit", type: :view do
  before(:each) do
    @custom_manifestation_label = assign(:custom_manifestation_label, CustomManifestationLabel.create!(
      :library_group => LibraryGroup.first,
      :label => "test"
    ))
  end

  it "renders the edit custom_manifestation_label form" do
    render

    assert_select "form[action=?][method=?]", custom_manifestation_label_path(@custom_manifestation_label), "post" do

      assert_select "input[name=?]", "custom_manifestation_label[library_group_id]"

      assert_select "input[name=?]", "custom_manifestation_label[label]"
    end
  end
end
