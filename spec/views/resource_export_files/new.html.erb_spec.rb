require 'spec_helper'

describe "resource_export_files/new" do
  before(:each) do
    assign(:resource_export_file, stub_model(ResourceExportFile, user_id: 1).as_new_record)
    view.stub(:current_user).and_return(User.find(1))
  end

  it "renders new resource_export_file form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", resource_export_files_path, "post" do
    end
  end
end
