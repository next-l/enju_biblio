require "rails_helper.rb"

describe "manifestations/index" do
  before(:each) do
    @manifestations = assign(:manifestations,
      Kaminari.paginate_array( [
        FactoryBot.create(:manifestation),
      ], total_count: 1).page(1)
    )
    @index_agent = {}
    @count = { query_result: 1 }
    @reservable_facet = @carrier_type_facet = @language_facet = @library_facet = @pub_year_facet = []
    @seconds = 0
    @max_number_of_results = 500
    @request.stub(:params).and_return(ActionController::Parameters.new(per_page: 50).permit(:per_page))
  end

  describe "sort_by menu" do
    it "should reflect per_page params for views" do
      render
      expect(rendered).to have_selector "select#per_page option[value='50'][selected='selected']"
    end
  end
end

