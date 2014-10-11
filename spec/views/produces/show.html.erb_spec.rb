require 'spec_helper'

describe "produces/show" do
  before(:each) do
    @produce = assign(:produce, stub_model(Produce,
      :manifestation_id => 1,
      :agent_id => 1
    ))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{Manifestation.find(1).original_title}/)
  end
end
