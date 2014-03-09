class AgentImportResultsController < ApplicationController
  before_action :set_agent_import_result, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  def index
    authorize AgentImportResult
    @agent_import_file = AgentImportFile.where(:id => params[:agent_import_file_id]).first
    if @agent_import_file
      @agent_import_results = @agent_import_file.agent_import_results.page(params[:page])
    else
      @agent_import_results = AgentImportResult.page(params[:page])
    end
  end

  def show
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_import_result
      @agent_import_result = AgentImportResult.find(params[:id])
      authorize @agent_import_result
    end
end
