require "rails_helper.rb"

describe "items/index.json.jbuilder", solr: true do
  before(:each) do
    item = FactoryBot.create(:item)
    @items = assign(:items, [item] )
  end

  it "should export JSON format" do
    params[:format] = "json"
    render
    expect(rendered).not_to match(/memo/)
  end
end

