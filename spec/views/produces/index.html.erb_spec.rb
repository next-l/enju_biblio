require 'rails_helper'

describe "produces/index" do
  before(:each) do
    @manifestation = FactoryBot.create(:manifestation)
    2.times do
      @manifestation.publishers << FactoryBot.create(:agent)
    end
    assign(:produces, @manifestation.produces.page(1))
  end

  it "renders a list of produces" do
    allow(view).to receive(:policy).and_return double(create?: true, update?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h2", text: @manifestation.original_title, count: 1
  end
end
