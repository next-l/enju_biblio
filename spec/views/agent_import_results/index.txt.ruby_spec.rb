require 'rails_helper'

describe "agent_import_results/index.txt.ruby" do
  fixtures :all

  before(:each) do
    file = AgentImportFile.create(
      agent_import: File.new("#{Rails.root}/../fixtures/files/agent_import_file_sample1.tsv"),
      user: users(:admin)
    )
    file.import_start
    assign(:agent_import_file_id, file.id)
    assign(:agent_import_results, AgentImportFile.find(file.id).agent_import_results)
  end

  it "renders a list of agent_import_results" do
    render
    expect(CSV.parse(rendered, headers: true, col_sep: "\t").first['full_name']).to eq 'フルネーム'
  end
end
