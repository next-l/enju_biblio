require 'rails_helper'

describe "resource_import_results/index.txt.ruby" do
  fixtures :all

  before(:each) do
    file = ResourceImportFile.new(
      default_shelf_id: 3,
      user: users(:admin),
      edit_mode: 'create'
    )
    file.attachment.attach(io: File.new("#{Rails.root}/../fixtures/files/resource_import_file_sample1.tsv"), filename: 'attachment.txt')
    file.save
    file.import_start
    assign(:resource_import_file, file)
    assign(:resource_import_results, file.resource_import_results)
  end

  it "renders a list of resource_import_results", vcr: true do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['row_num']).to eq '1'
    expect(CSV.parse(rendered, headers: true, col_sep: "\t")[12]['manifestation']).to be_present
  end
end
