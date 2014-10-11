require 'spec_helper'

describe "creates/show" do
  before(:each) do
    @create = assign(:create, stub_model(Create,
      :work_id => 1,
      :agent_id => 1
    ))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
