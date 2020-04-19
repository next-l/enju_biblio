require 'rails_helper'

describe "resource_import_results/show" do
  fixtures :all

  before(:each) do
    @resource_import_result = resource_import_results(:one)
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_user).and_return(admin)
  end

  it "renders a resource_import_result" do
    render
    expect(rendered).to match /original_title/
  end

  it "renders even if a resource_import_file is deleted" do
    #@resource_import_result.resource_import_file = nil
    @resource_import_result.resource_import_file.delete
    @resource_import_result.resource_import_file = nil
    render
    expect(rendered).to match /original_title/
  end
end
