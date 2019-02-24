require 'rails_helper'

describe "resource_import_results/index" do
  fixtures :all

  before(:each) do
    2.times do
      FactoryBot.create(:resource_import_result)
    end
    @resource_import_results = ResourceImportResult.page(1)
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_resource).and_return(admin)
  end

  it "renders a list of resource_import_results" do
    render
    expect(rendered).to match /#{resource_import_result_path(@resource_import_results.first)}/
  end

  context "with @resource_import_file" do
    before do
      @resource_import_file = ResourceImportFile.first
    end

    it "renders a list of resource_import_results for the resource_import_file" do
      render
      expect(view).to render_template "resource_import_results/_list_lines"
      expect(rendered).to match /#{resource_import_result_path(@resource_import_results.first)}/
      expect(rendered).to match /<td>1<\/td>/
    end
  end
end
