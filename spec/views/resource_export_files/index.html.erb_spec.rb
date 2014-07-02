require 'spec_helper'

describe "resource_export_files/index" do
  before(:each) do
    assign(:resource_export_files, [
      stub_model(ResourceExportFile),
      stub_model(ResourceExportFile)
    ])
  end

  it "renders a list of resource_export_files" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
