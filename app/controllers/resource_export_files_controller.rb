class ResourceExportFilesController < ApplicationController
  before_action :set_resource_export_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /resource_export_files
  def index
    @resource_export_files = ResourceExportFile.order('id DESC').page(params[:page])
  end

  # GET /resource_export_files/1
  def show
  end

  # GET /resource_export_files/new
  def new
    @resource_export_file = ResourceExportFile.new
    @resource_export_file.user = current_user
  end

  # GET /resource_export_files/1/edit
  def edit
  end

  # POST /resource_export_files
  def create
    @resource_export_file = ResourceExportFile.new(resource_export_file_params)

    if @resource_export_file.save
      Resque.enqueue(ExportFile, @resource_export_file.id)
      redirect_to @resource_export_file, notice: 'エクスポートのタスクが設定されました。エクスポートが完了しましたらメッセージでお知らせします。現在の状態は「エクスポートの一覧」でも確認できます。'
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
    end

    # Only allow a trusted parameter "white list" through.
    def resource_export_file_params
      params.require(:resource_export_file).permit(:user_id)#, :resource_export)
    end
end
