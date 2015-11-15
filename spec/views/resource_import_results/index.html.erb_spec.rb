require 'spec_helper'

describe "resource_import_results/index" do
  fixtures :all

  before(:each) do
    assign(:resource_import_results, ResourceImportResult.page(1))
    admin = User.find('enjuadmin')
    view.stub(:current_resource).and_return(admin)
  end

  it "renders a list of resource_import_results" do
    render
    expect(rendered).to match /MyString/
  end

  context "with @resource_import_file" do
    before(:each) do
      @resource_import_file = ResourceImportFile.find(1)
      @resource_import_results = ResourceImportResult.where(resource_import_file_id: 1).page(1)
    end
    it "renders a list of resource_import_results for the resource_import_file" do
      render
      expect(view).to render_template "resource_import_results/_list_lines"
      expect(rendered).to match /MyString/
      expect(rendered).to match /<td>1<\/td>/
    end
  end
end
