require 'spec_helper'

describe "resource_export_files/edit" do
  before(:each) do
    @resource_export_file = assign(:resource_export_file, stub_model(ResourceExportFile, user_id: 1))
    view.stub(:current_user).and_return(User.find(1))
  end

  it "renders the edit resource_export_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", resource_export_file_path(@resource_export_file), "post" do
    end
  end
end
