require 'rails_helper'

describe "realizes/show" do
  fixtures :manifestations

  before(:each) do
    @realize = assign(:realize, stub_model(Realize,
      expression_id: manifestations(:manifestation_00001).id,
      agent_id: 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/#{manifestations(:manifestation_00001).original_title}/)
  end
end
