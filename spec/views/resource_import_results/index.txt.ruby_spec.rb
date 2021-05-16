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
    assign(:resource_import_file, file)
    assign(:resource_import_results, file.resource_import_results)
  end

  it "renders a list of resource_import_results", vcr: true do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['original_title']).to eq 'タイトル'
    expect(CSV.parse(rendered, headers: true, col_sep: "\t")[12]['imported_manifestation_id']).to be_present
  end
end
