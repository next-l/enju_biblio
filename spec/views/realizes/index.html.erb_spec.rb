require 'rails_helper'

describe "realizes/index" do
  before(:each) do
    assign(:realizes, Kaminari::paginate_array([
      stub_model(Realize,
        :expression_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
        :agent_id => '29ef327d-172b-451f-9e9c-36f8831ccefe'
      ),
      stub_model(Realize,
        :expression_id => '1ff5b88a-1964-4db0-acb3-ae1d9e3a307e',
        :agent_id => '29ef327d-172b-451f-9e9c-36f8831ccefe'
      )
    ]).page(1))
  end

  it "renders a list of realizes" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => Manifestation.find('1ff5b88a-1964-4db0-acb3-ae1d9e3a307e').original_title, :count => 2
  end
end
