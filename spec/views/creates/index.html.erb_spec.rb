require 'rails_helper'

describe "creates/index" do
  fixtures :manifestations, :agents

  before(:each) do
    assign(:creates, Kaminari.paginate_array([
      stub_model(Create,
        work_id: manifestations(:manifestation_00001).id,
        agent_id: agents(:agent_00001).id
      ),
      stub_model(Create,
        work_id: manifestations(:manifestation_00001).id,
        agent_id: agents(:agent_00002).id
      )
    ]).page(1))
  end

  it "renders a list of creates" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: manifestations(:manifestation_00001).original_title, count: 2
  end
end
