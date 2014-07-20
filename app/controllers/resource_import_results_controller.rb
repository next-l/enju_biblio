class ResourceImportResultsController < InheritedResources::Base
  respond_to :html, :json, :txt
  load_and_authorize_resource
  has_scope :file_id
  actions :index, :show, :destroy

  def index
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
  end
end
