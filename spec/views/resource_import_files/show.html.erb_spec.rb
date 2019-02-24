require 'rails_helper'

describe "resource_import_files/show" do
  fixtures :all

  before(:each) do
    2.times do
      FactoryBot.create(:resource_import_result)
    end
    @resource_import_results = ResourceImportResult.page(1)
    @resource_import_file = @resource_import_results.first.resource_import_file
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_user).and_return(admin)
  end

  it "renders a resource_import_file" do
    render
    expect(rendered).to match /Showing Resource import file/
  end
  it "renders a list of resource_import_results" do
    render
    expect(rendered).to match /<table/
    expect(rendered).to render_template "resource_import_files/_results"
  end
end
