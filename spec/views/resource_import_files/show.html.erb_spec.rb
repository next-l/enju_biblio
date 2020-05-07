require 'rails_helper'

describe "resource_import_files/show" do
  fixtures :all

  before(:each) do
    file = resource_import_files(:resource_import_file_00001)
    file.attachment.attach(io: File.new("#{Rails.root}/../../examples/resource_import_file_sample1.tsv"), filename: 'attachment.txt')
    assign(:resource_import_file, file)
    assign(:resource_import_results, 
      Kaminari.paginate_array(file.resource_import_results).page(1))
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_user).and_return(admin)
  end

  it "renders a resource_import_file" do
    render
    expect(rendered).to match /MyText/
  end
  it "renders a list of resource_import_results" do
    render
    expect(rendered).to match /<table/
    expect(rendered).to render_template "resource_import_files/_results"
  end
end
