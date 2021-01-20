require 'rails_helper'

describe "creates/index" do
  before(:each) do
    @work = FactoryBot.create(:manifestation)
    2.times do
      @work.creators << FactoryBot.create(:agent)
    end
    assign(:creates, @work.creates.page(1))
  end

  it "renders a list of creates" do
    allow(view).to receive(:policy).and_return double(create?: true, destroy?: true)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h2", text: @work.original_title, count: 1
  end
end
