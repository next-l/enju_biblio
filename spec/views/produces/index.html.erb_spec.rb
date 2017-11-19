require 'rails_helper'

describe "produces/index" do
  before(:each) do
    assign(:produces, Kaminari::paginate_array([
      stub_model(Produce,
        :manifestation_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
        :agent_id => 2
      ),
      stub_model(Produce,
        :manifestation_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
        :agent_id => 2
      )
    ]).page(1))
  end

  it "renders a list of produces" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => Manifestation.find(1).original_title, :count => 2
  end
end
