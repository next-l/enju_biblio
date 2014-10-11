class AgentImportFilesController < ApplicationController
  before_action :set_agent_import_file, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /agent_import_files
  def index
    authorize AgentImportFile
    @agent_import_files = AgentImportFile.page(params[:page])
  end

  # GET /agent_import_files/1
  def show
    if @agent_import_file.agent_import.path
      unless Setting.uploaded_file.storage == :s3
        file = @agent_import_file.agent_import.path
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agent_import_file }
      format.download {
        if Setting.uploaded_file.storage == :s3
          redirect_to @agent_import_file.agent_import.expiring_url(10)
        else
          send_file file, filename: @agent_import_file.agent_import_file_name, type: 'application/octet-stream'
        end
      }
    end
  end

  # GET /agent_import_files/new
  def new
    @agent_import_file = AgentImportFile.new
    authorize @agent_import_file
  end

  # GET /agent_import_files/1/edit
  def edit
  end

  # POST /agent_import_files
  def create
    authorize AgentImportFile
    @agent_import_file = AgentImportFile.new(agent_import_file_params)
    @agent_import_file.user = current_user

    if @agent_import_file.save
      if @agent_import_file.mode == 'import'
        Resque.enqueue(AgentImportFileQueue, @agent_import_file.id)
      end
      redirect_to @agent_import_file, notice: t('controller.successfully_created', model: t('activerecord.models.agent_import_file'))
    else
      render action: 'new'
    end
  end

  # PUT /agent_import_files/1
  def update
    if @agent_import_file.update(agent_import_file_params)
      if @agent_import_file.mode == 'import'
        Resque.enqueue(AgentImportFileQueue, @agent_import_file.id)
      end
      redirect_to @agent_import_file, notice: t('controller.successfully_updated', model: t('activerecord.models.agent_import_file'))
    else
      render :edit
    end
  end

  # DELETE /agent_import_files/1
  def destroy
    @agent_import_file.destroy
    redirect_to agent_import_files_url, notice: t('controller.successfully_destroyed', model: t('activerecord.models.agent_import_file'))
  end

  private
  def set_agent_import_file
    @agent_import_file = AgentImportFile.find(params[:id])
    authorize @agent_import_file
  end

  def agent_import_file_params
    params.require(:agent_import_file).permit(
      :agent_import, :edit_mode, :user_encoding, :mode
    )
  end
end
