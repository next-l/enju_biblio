require 'rails_helper'

describe "resource_import_files/index" do
  fixtures :all

  before(:each) do
    assign(:resource_import_files, ResourceImportFile.page(1))
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_resource).and_return(admin)
  end

  it "renders a list of resource_import_files" do
    render
    expect(rendered).to match /MyString/
  end
end
