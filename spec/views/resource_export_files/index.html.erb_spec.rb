require 'rails_helper'

describe "resource_export_files/index" do
  fixtures :all

  before(:each) do
    2.times do
      FactoryBot.create(:resource_export_file)
    end
    assign(:resource_export_files, ResourceExportFile.page(1))
  end

  it "renders a list of resource_export_files" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
