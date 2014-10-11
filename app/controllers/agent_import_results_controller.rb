class AgentImportResultsController < ApplicationController
  before_action :set_agent_import_result, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize AgentImportResult
    @agent_import_file = AgentImportFile.where(id: params[:agent_import_file_id]).first
    if @agent_import_file
      if params[:format] == 'txt'
        @agent_import_results = @agent_import_file.agent_import_results
      else
        @agent_import_results = @agent_import_file.agent_import_results.page(params[:page])
      end
    else
      @agent_import_results = AgentImportResult.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agent_import_results }
      format.txt
    end
  end

  # GET /agent_import_results/1
  def show
  end

  # DELETE /agent_import_results/1
  def destroy
    @agent_import_result.destroy

    respond_to do |format|
      format.html { redirect_to agent_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.agent_import_result')) }
      format.json { head :no_content }
    end
  end

  def show
  end

  def destroy
    @agent_import_result.destroy
    redirect_to agent_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.agent_import_result'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_import_result
      @agent_import_result = AgentImportResult.find(params[:id])
      authorize @agent_import_result
    end
end
