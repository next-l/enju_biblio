class AgentImportResultsController < InheritedResources::Base
  respond_to :html, :json, :txt
  load_and_authorize_resource
  has_scope :file_id
  actions :index, :show, :destroy

  def index
    @agent_import_file = AgentImportFile.where(:id => params[:agent_import_file_id]).first
    if @agent_import_file
      @agent_import_results = @agent_import_file.agent_import_results.page(params[:page])
    else
      @agent_import_results = AgentImportResult.page(params[:page])
    end
  end
end
