require "rails_helper.rb"

describe "manifestations/index.json.jbuilder" do
  before(:each) do
    manifestation = FactoryBot.create(:manifestation)
    @manifestations = assign(:manifestations, [manifestation] )
    @library_group = LibraryGroup.first
    view.stub(:filtered_params).and_return(ActionController::Parameters.new(per_page: 50).permit([:per_page]))
  end

  it "should export JSON format" do
    params[:format] = "rdf"
    render
    JSON.parse(rendered)['total_count'].to eq Manifestation.count
  end
end

