class ResourceImportResultsController < ApplicationController
  before_action :set_resource_import_result, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  def index
    authorize ResourceImportResult
    @resource_import_file = ResourceImportFile.where(:id => params[:resource_import_file_id]).first
    if @resource_import_file
      @resource_import_results = @resource_import_file.resource_import_results.page(params[:page])
    else
      @resource_import_results = ResourceImportResult.page(params[:page])
    end
  end

  def show
  end

  def destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_import_result
      @resource_import_result = ResourceImportResult.find(params[:id])
      authorize @resource_import_result
    end
end
