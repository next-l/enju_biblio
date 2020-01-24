require "rails_helper.rb"
require "pundit/rspec"

describe "items/index" do
  before(:each) do
    @items = assign(:items,
      Kaminari.paginate_array( [
        FactoryBot.create(:item),
      ], total_count: 1).page(1)
    )
    user = FactoryBot.create(:librarian)
    allow(view).to receive(:policy) do |record|
      Pundit.policy(user, record)
    end
  end

  describe "item index" do
    it "should render index" do
      view.stub(:filtered_params).and_return(ActionController::Parameters.new().permit)
      render
      expect(rendered).to have_selector "div.col"
    end
  end
end

