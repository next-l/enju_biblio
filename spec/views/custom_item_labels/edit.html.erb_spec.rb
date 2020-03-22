require 'rails_helper'

RSpec.describe "custom_item_labels/edit", type: :view do
  before(:each) do
    @custom_item_label = assign(:custom_item_label, CustomItemLabel.create!(
      :library_group => LibraryGroup.first,
      :label => "test"
    ))
  end

  it "renders the edit custom_item_label form" do
    render

    assert_select "form[action=?][method=?]", custom_item_label_path(@custom_item_label), "post" do

      assert_select "input[name=?]", "custom_item_label[library_group_id]"

      assert_select "input[name=?]", "custom_item_label[label]"
    end
  end
end
