require 'rails_helper'
describe "series_statement_merges/show" do
  before(:each) do
    @series_statement_merge = assign(:series_statement_merge, FactoryBot.create(:series_statement_merge))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
