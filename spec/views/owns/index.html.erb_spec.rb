require 'spec_helper'

describe "owns/index" do
  before(:each) do
    assign(:owns, Kaminari::paginate_array([
      stub_model(Own,
        :item_id => 1,
        :patron_id => 1
      ),
      stub_model(Own,
        :item_id => 1,
        :patron_id => 2
      )
    ]).page(1))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders a list of owns" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => Item.find(1).item_identifier, :count => 2
  end
end
