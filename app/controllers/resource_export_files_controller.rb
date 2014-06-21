class ResourceExportFilesController < InheritedResources::Base
  respond_to :html, :csv
  load_and_authorize_resource

  def index
    @resource_import_file = ResourceImportFile.where(:id => params[:resource_import_file_id]).first
  end
end
