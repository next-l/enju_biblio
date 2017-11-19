require 'rails_helper'

describe "owns/index" do
  before(:each) do
    assign(:owns, Kaminari::paginate_array([
      stub_model(Own,
        :item_id => '17eaea41-eacb-4e08-8e0b-70c6e62e3ed3',
        :agent_id => 1
      ),
      stub_model(Own,
        :item_id => '17eaea41-eacb-4e08-8e0b-70c6e62e3ed3',
        :agent_id => 2
      )
    ]).page(1))
  end

  it "renders a list of owns" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => Item.find('17eaea41-eacb-4e08-8e0b-70c6e62e3ed3').item_identifier, :count => 2
  end
end
