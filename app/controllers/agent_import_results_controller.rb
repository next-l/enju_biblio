class AgentImportResultsController < ApplicationController
  load_and_authorize_resource
  # GET /agent_import_results
  # GET /agent_import_results.json
  def index
    @agent_import_file = AgentImportFile.where(id: params[:agent_import_file_id]).first
    if @agent_import_file
      @agent_import_results = @agent_import_file.agent_import_results.page(params[:page])
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
  # GET /agent_import_results/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agent_import_result }
    end
  end

  # DELETE /agent_import_results/1
  # DELETE /agent_import_results/1.json
  def destroy
    @agent_import_result.destroy

    respond_to do |format|
      format.html { redirect_to agent_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.agent_import_result')) }
      format.json { head :no_content }
    end
  end

  private
  def agent_import_result_params
    params.require(:agent_import_result).permit(
      :agent_import_file_id, :agent_id, :body
    )
  end
end
