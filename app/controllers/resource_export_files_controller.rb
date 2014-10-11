class ResourceExportFilesController < ApplicationController
  before_action :set_resource_export_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /resource_export_files
  def index
    authorize ResourceExportFile
    @resource_export_files = ResourceExportFile.order('id DESC').page(params[:page])
  end

  # GET /resource_export_files/1
  def show
  end

  # GET /resource_export_files/new
  def new
    @resource_export_file = ResourceExportFile.new
    @resource_export_file.user = current_user
    authorize @resource_export_file
  end

  # GET /resource_export_files/1/edit
  def edit
  end

  # POST /resource_export_files
  def create
    @resource_export_file = ResourceExportFile.new(resource_export_file_params)
    @resource_export_file.user = current_user

    if @resource_export_file.save
      if @resource_export_file.mode == 'export'
        Resque.enqueue(ResourceExportFileQueue, @resource_export_file.id)
      end
      redirect_to @resource_export_file, notice: t('export.resource_export_task_created')
    else
      render :new
    end
  end

  # PATCH/PUT /resource_export_files/1
  def update
    if @resource_export_file.update(resource_export_file_params)
      redirect_to @resource_export_file, notice: t('controller.successfully_updated', :model => t('activerecord.models.resource_export_file'))
    else
      render :edit
    end
  end

  # DELETE /resource_export_files/1
  def destroy
    @resource_export_file.destroy
    redirect_to resource_export_files_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.resource_export_file'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource_export_file
      @resource_export_file = ResourceExportFile.find(params[:id])
      authorize @resource_export_file
    end

    # Only allow a trusted parameter "white list" through.
    def resource_export_file_params
      params.require(:resource_export_file).permit(:user_id, :mode)
    end
end
