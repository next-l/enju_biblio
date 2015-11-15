require 'spec_helper'

describe "creates/index" do
  before(:each) do
    assign(:creates, Kaminari::paginate_array([
      stub_model(Create,
        :work_id => 1,
        :agent_id => 1
      ),
      stub_model(Create,
        :work_id => 1,
        :agent_id => 2
      )
    ]).page(1))
  end

  it "renders a list of creates" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: Manifestation.find(1).original_title, count: 2
  end
end
