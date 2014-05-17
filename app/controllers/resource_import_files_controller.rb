class ResourceImportFilesController < ApplicationController
  before_action :set_resource_import_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  #after_action :verify_policy_scoped, :only => :index

  # GET /resource_import_files
  # GET /resource_import_files.json
  def index
    authorize ResourceImportFile
    @resource_import_files = ResourceImportFile.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @resource_import_files }
    end
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
    @resource_import_file = ResourceImportFile.new(resource_import_file_params)
    authorize @resource_import_file
    @resource_import_file.user = current_user

    respond_to do |format|
      if @resource_import_file.save
        format.html { redirect_to @resource_import_file, :notice => t('controller.successfully_created', :model => t('activerecord.models.resource_import_file')) }
        format.json { render :json => @resource_import_file, :status => :created, :location => @resource_import_file }
      else
        format.html { render :action => "new" }
        format.json { render :json => @resource_import_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resource_import_files/1
  # PUT /resource_import_files/1.json
  def update
    respond_to do |format|
      if @resource_import_file.update_attributes(resource_import_file_params)
        format.html { redirect_to @resource_import_file, :notice => t('controller.successfully_updated', :model => t('activerecord.models.resource_import_file')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @resource_import_file.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_import_files/1
  # DELETE /resource_import_files/1.json
  def destroy
    @resource_import_file.destroy

    respond_to do |format|
      format.html { redirect_to resource_import_files_url }
      format.json { head :no_content }
    end
  end

  private
  def set_resource_import_file
    @resource_import_file = ResourceImportFile.find(params[:id])
    authorize @resource_import_file
  end

  def resource_import_file_params
    params.require(:resource_import_file).permit(
      :resource_import, :edit_mode
    )
  end
end
