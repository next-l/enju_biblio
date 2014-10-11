require 'spec_helper'

describe "produces/index" do
  before(:each) do
    assign(:produces, Kaminari::paginate_array([
      stub_model(Produce,
        :manifestation_id => 1,
        :agent_id => 2
      ),
      stub_model(Produce,
        :manifestation_id => 1,
        :agent_id => 2
      )
    ]).page(1))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders a list of produces" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => Manifestation.find(1).original_title, :count => 2
  end
end
