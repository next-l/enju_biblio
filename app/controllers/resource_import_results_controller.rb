class ResourceImportResultsController < ApplicationController
  load_and_authorize_resource
  # GET /resource_import_results
  # GET /resource_import_results.json
  def index
    @resource_import_file = ResourceImportFile.where(id: params[:resource_import_file_id]).first
    if @resource_import_file
      @resource_import_results = @resource_import_file.resource_import_results.page(params[:page])
    else
      @resource_import_results = ResourceImportResult.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resource_import_results }
      format.txt
    end
  end

  # GET /resource_import_results/1
  # GET /resource_import_results/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource_import_result }
    end
  end

  # DELETE /resource_import_results/1
  # DELETE /resource_import_results/1.json
  def destroy
    @resource_import_result.destroy

    respond_to do |format|
      format.html { redirect_to resource_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.resource_import_result')) }
      format.json { head :no_content }
    end
  end

  private
  def resource_import_result_files
    params.require(:resource_import_result).permit(
      :resource_import_file_id, :manifestation_id, :item_id, :body
    )
  end
end
