require 'rails_helper'

describe "series_statement_merge_lists/show" do
  fixtures :series_statement_merge_lists

  before(:each) do
    @series_statement_merge_list = series_statement_merge_lists(:series_statement_merge_list_00001)
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
  end
end
