require 'spec_helper'

describe "resource_export_files/show" do
  before(:each) do
    @resource_export_file = assign(:resource_export_file, stub_model(ResourceExportFile))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
