require 'rails_helper'

describe "agent_import_results/index" do
  fixtures :all

  before(:each) do
    assign(:agent_import_results, AgentImportResult.page(1))
    admin = User.find_by(username: 'enjuadmin')
    view.stub(:current_agent).and_return(admin)
  end

  it "renders a list of agent_import_results" do
    render
    expect(rendered).to match /MyString/
  end

  context "with @agent_import_file" do
    before(:each) do
      @agent_import_file = AgentImportFile.find(1)
      @agent_import_results = AgentImportResult.where(agent_import_file_id: 1).page(1)
    end
    it "renders a list of agent_import_results for the agent_import_file" do
      render
      expect(view).to render_template "agent_import_results/_list_lines"
      expect(rendered).to match /MyString/
      expect(rendered).to match /<td>1<\/td>/
    end
  end
end
