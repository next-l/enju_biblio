class ResourceImportFilesController < ApplicationController
  before_action :set_resource_import_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /resource_import_files
  # GET /resource_import_files.json
  def index
    authorize ResourceImportFile
    @resource_import_files = ResourceImportFile.page(params[:page])
  end

  # GET /resource_import_files/1
  # GET /resource_import_files/1.json
  def show
    if @resource_import_file.resource_import.path
      unless Setting.uploaded_file.storage == :s3
        file = @resource_import_file.resource_import.path
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @resource_import_file }
      format.download {
        if Setting.uploaded_file.storage == :s3
          redirect_to @resource_import_file.resource_import.expiring_url(10)
        else
          send_file file, :filename => @resource_import_file.resource_import_file_name, :type => 'application/octet-stream'
        end
      }
    end
  end

  # GET /resource_import_files/new
  # GET /resource_import_files/new.json
  def new
    @resource_import_file = ResourceImportFile.new
    authorize @resource_import_file
  end

  # GET /resource_import_files/1/edit
  def edit
  end

  # POST /resource_import_files
  # POST /resource_import_files.json
  def create
    authorize ResourceImportFile
    @resource_import_file = ResourceImportFile.new(resource_import_file_params)
    @resource_import_file.user = current_user

    if @resource_import_file.save
      if @resource_import_file.mode == 'import'
        Resque.enqueue(ResourceImportFileQueue, @resource_import_file.id)
      end
      redirect_to @resource_import_file, notice: t('controller.successfully_created', :model => t('activerecord.models.resource_import_file'))
    else
      render action: 'new'
    end
  end

  # PUT /resource_import_files/1
  # PUT /resource_import_files/1.json
  def update
    if @resource_import_file.update(resource_import_file_params)
      if @resource_import_file.mode == 'import'
        Resque.enqueue(ResourceImportFileQueue, @resource_import_file.id)
      end
      redirect_to @resource_import_file, notice: t('controller.successfully_updated', :model => t('activerecord.models.resource_import_file'))
    else
      render :edit
    end
  end

  # DELETE /resource_import_files/1
  # DELETE /resource_import_files/1.json
  def destroy
    @resource_import_file.destroy
    redirect_to resource_import_files_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.resource_import_file'))
  end

  private
  def set_resource_import_file
    @resource_import_file = ResourceImportFile.find(params[:id])
    authorize @resource_import_file
  end

  def resource_import_file_params
    params.require(:resource_import_file).permit(
      :resource_import, :edit_mode, :user_encoding, :mode
    )
  end
end
