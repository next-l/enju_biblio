class ResourceImportFilesController < ApplicationController
  load_and_authorize_resource

  # GET /resource_import_files
  # GET /resource_import_files.json
  def index
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @resource_import_file }
    end
  end

  # GET /resource_import_files/1/edit
  def edit
  end

  # POST /resource_import_files
  # POST /resource_import_files.json
  def create
<<<<<<< HEAD
    @resource_import_file = ResourceImportFile.new(params[:resource_import_file])
=======
    authorize ResourceImportFile
    @resource_import_file = ResourceImportFile.new(resource_import_file_params)
>>>>>>> 895102c... cleaned up
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
    respond_to do |format|
      if @resource_import_file.update_attributes(params[:resource_import_file])
        if @resource_import_file.mode == 'import'
          Resque.enqueue(ResourceImportFileQueue, @resource_import_file.id)
        end
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
end
