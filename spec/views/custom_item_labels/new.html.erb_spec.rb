require 'rails_helper'

RSpec.describe "custom_item_labels/new", type: :view do
  before(:each) do
    assign(:custom_item_label, CustomItemLabel.new(
      :library_group => LibraryGroup.first,
      :label => "test"
    ))
  end

  it "renders new custom_item_label form" do
    render

    assert_select "form[action=?][method=?]", custom_item_labels_path, "post" do

      assert_select "input[name=?]", "custom_item_label[library_group_id]"

      assert_select "input[name=?]", "custom_item_label[label]"
    end
  end
end
