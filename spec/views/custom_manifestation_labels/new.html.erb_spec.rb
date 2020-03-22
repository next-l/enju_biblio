require 'rails_helper'

RSpec.describe "custom_manifestation_labels/new", type: :view do
  before(:each) do
    assign(:custom_manifestation_label, CustomManifestationLabel.new(
      :library_group => LibraryGroup.first,
      :label => "test"
    ))
  end

  it "renders new custom_manifestation_label form" do
    render

    assert_select "form[action=?][method=?]", custom_manifestation_labels_path, "post" do

      assert_select "input[name=?]", "custom_manifestation_label[library_group_id]"

      assert_select "input[name=?]", "custom_manifestation_label[label]"
    end
  end
end
