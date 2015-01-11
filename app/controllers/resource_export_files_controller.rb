class ResourceExportFilesController < ApplicationController
  load_and_authorize_resource

  # GET /resource_export_files
  # GET /resource_export_files.json
  def index
    @resource_export_files = ResourceExportFile.order('id DESC').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @resource_export_files }
    end
  end

  # GET /resource_export_files/1
  # GET /resource_export_files/1.json
  def show
    if @resource_export_file.resource_export.path
      unless Rails.application.config_for(:enju_leaf)["uploaded_file"]["storage"] == :s3
        file = @resource_export_file.resource_export.path
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource_export_file }
      format.download {
        if Rails.application.config_for(:enju_leaf)["uploaded_file"]["storage"] == :s3
          redirect_to @resource_export_file.resource_export.expiring_url(10)
        else
          send_file file, filename: @resource_export_file.resource_export_file_name, type: 'application/octet-stream'
        end
      }
    end
  end

  # GET /resource_export_files/new
  # GET /resource_export_files/new.json
  def new
    @resource_export_file = ResourceExportFile.new
    @resource_export_file.user = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource_export_file }
    end
  end

  # GET /resource_export_files/1/edit
  def edit
  end

  # POST /resource_export_files
  # POST /resource_export_files.json
  def create
    @resource_export_file = ResourceExportFile.new(resource_export_file_params)
    @resource_export_file.user = current_user

    respond_to do |format|
      if @resource_export_file.save
        if @resource_export_file.mode == 'export'
          ResourceExportFileJob.perform_later(@resource_export_file)
        end
        format.html { redirect_to @resource_export_file, notice: t('export.successfully_created', model: t('activerecord.models.resource_export_file')) }
        format.json { render json: @resource_export_file, status: :created, location: @resource_export_file }
      else
        format.html { render action: "new" }
        format.json { render json: @resource_export_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resource_export_files/1
  # PUT /resource_export_files/1.json
  def update
    respond_to do |format|
      if @resource_export_file.update_attributes(resource_export_file_params)
        if @resource_export_file.mode == 'export'
          ResourceExportFileJob.perform_later(@resource_export_file)
        end
        format.html { redirect_to @resource_export_file, notice: t('controller.successfully_updated', model: t('activerecord.models.resource_export_file')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource_export_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resource_export_files/1
  # DELETE /resource_export_files/1.json
  def destroy
    @resource_export_file.destroy

    respond_to do |format|
      format.html { redirect_to resource_export_files_url }
      format.json { head :no_content }
    end
  end

  private
  def resource_export_file_params
    params.require(:resource_export_file).permit(:mode)
  end
end
