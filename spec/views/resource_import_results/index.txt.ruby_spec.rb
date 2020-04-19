require 'rails_helper'

describe "resource_import_results/index.txt.ruby" do
  fixtures :all

  before(:each) do
    file = ResourceImportFile.create(
      resource_import: File.new("#{Rails.root}/../../examples/resource_import_file_sample1.tsv"),
      default_shelf_id: 3,
      user: users(:admin)
    )
    file.import_start
    assign(:resource_import_file_id, file.id)
    assign(:resource_import_results, ResourceImportFile.find(file.id).resource_import_results)
  end

  it "renders a list of resource_import_results" do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['original_title']).to eq 'タイトル'
    expect(CSV.parse(rendered, headers: true, col_sep: "\t")[10]['original_title']).to eq 'test8'
  end
end
