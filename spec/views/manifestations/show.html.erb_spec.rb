require 'spec_helper'

describe "manifestations/show" do
  fixtures :all

  before(:each) do
    assign(:manifestation, FactoryGirl.create(:manifestation))
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end

  describe "identifier_link" do
    it "renders a link to CiNii Books" do
      assign(:manifestation, manifestations(:manifestation_00217))
      render
      rendered.should include '<a href="http://ci.nii.ac.jp/ncid/BN15603730">BN15603730</a>'
    end
  end
end
