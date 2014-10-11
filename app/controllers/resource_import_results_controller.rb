class ResourceImportResultsController < ApplicationController
  before_action :set_resource_import_result, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def index
    authorize ResourceImportResult
    @resource_import_file = ResourceImportFile.where(:id => params[:resource_import_file_id]).first
    if @resource_import_file
      if params[:format] == 'txt'
        @resource_import_results = @resource_import_file.resource_import_results
      else
        @resource_import_results = @resource_import_file.resource_import_results.page(params[:page])
      end
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
  def show
  end

  # DELETE /resource_import_results/1
  def destroy
    @resource_import_result.destroy
    redirect_to resource_import_results_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.resource_import_result'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_import_result
      @resource_import_result = ResourceImportResult.find(params[:id])
      authorize @resource_import_result
    end
end
