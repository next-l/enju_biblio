require 'rails_helper'

describe "resource_export_files/index" do
  fixtures :all

  before(:each) do
    assign(:resource_export_files, Kaminari::paginate_array([
      stub_model(ResourceExportFile, user_id: 1),
      stub_model(ResourceExportFile, user_id: 1)
    ]).page(1))
  end

  it "renders a list of resource_export_files" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
