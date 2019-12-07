require "rails_helper.rb"

describe "manifestations/index.json.jbuilder", solr: true do
  before(:each) do
    manifestation = FactoryBot.create(:manifestation)
    @manifestations = assign(:manifestations, [manifestation] )
    @library_group = LibraryGroup.first
    @count = {query_result: Manifestation.search.total}
    view.stub(:filtered_params).and_return(ActionController::Parameters.new(per_page: 50).permit([:per_page]))
  end

  it "should export JSON format" do
    params[:format] = "json"
    render
    expect(JSON.parse(rendered)['total_count']).to eq Manifestation.search.total
  end
end

