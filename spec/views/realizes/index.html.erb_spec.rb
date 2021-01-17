require 'rails_helper'

describe "realizes/index" do
  before(:each) do
    @expression = FactoryBot.create(:manifestation)
    2.times do
      @expression.publishers << FactoryBot.create(:agent)
    end
    assign(:realizes, @expression.realizes.page(1))
  end

  it "renders a list of realizes" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", text: @expression.original_title, count: 2
  end
end
