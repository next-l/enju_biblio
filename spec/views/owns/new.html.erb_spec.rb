require 'rails_helper'

describe "owns/new" do
  before(:each) do
    assign(:own, stub_model(Own,
      :item_id => 1,
      :agent_id => '=> 727eae50-90a8-419b-ab0c-bd8f9a3a2873'
    ).as_new_record)
  end

  it "renders new own form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => owns_path, :method => "post" do
      assert_select "input#own_item_id", :name => "own[item_id]"
    end
  end
end
