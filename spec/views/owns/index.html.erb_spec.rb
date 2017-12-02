require 'rails_helper'

describe "owns/index" do
  before(:each) do
    assign(:owns, Kaminari::paginate_array([
      stub_model(Own,
        :item_id => '17eaea41-eacb-4e08-8e0b-70c6e62e3ed3',
        :agent_id => '727eae50-90a8-419b-ab0c-bd8f9a3a2873'
      ),
      stub_model(Own,
        :item_id => '17eaea41-eacb-4e08-8e0b-70c6e62e3ed3',
        :agent_id => '29ef327d-172b-451f-9e9c-36f8831ccefe'
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
