require 'rails_helper'

describe "realize_types/index" do
  before(:each) do
    assign(:realize_types, [
      stub_model(RealizeType,
        name: "Name",
        display_name: "ja: テキスト",
        note: "MyText",
        position: 1
      ),
      stub_model(RealizeType,
        name: "Name",
        display_name: "ja: テキスト",
        note: "MyText",
        position: 1
      )
    ])
  end

  it "renders a list of realize_types" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: "Name".to_s, count: 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /テキスト/
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td:nth-child(3)", /MyText/
  end
end
