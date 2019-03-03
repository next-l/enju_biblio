require "rails_helper.rb"
require "pundit/rspec"

describe "items/index" do
  before(:each) do
    @items = assign(:items,
      Kaminari.paginate_array( [
        FactoryBot.create(:item),
      ], total_count: 1).page(1)
    )
    facet1 = double("Facet for available on shelf")
    allow(facet1).to receive(:count).and_return(1)
    allow(facet1).to receive(:value).and_return("Available On Shelf")
    user = FactoryBot.create(:librarian)
    allow(view).to receive(:policy) do |record|
      Pundit.policy(user, record)
    end
  end

  it "renders a list of items" do
    render
  end
end

