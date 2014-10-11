class AgentTypesController < ApplicationController
  before_action :set_agent_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /agent_types
  def index
    authorize AgentType
    @agent_types = policy_scope(AgentType).order(:position)
  end

  # GET /agent_types/1
  def show
  end

  # GET /agent_types/new
  def new
    @agent_type = AgentType.new
    authorize @agent_type
  end

  # GET /agent_types/1/edit
  def edit
  end

  # POST /agent_types
  def create
    @agent_type = AgentType.new(agent_type_params)
    authorize @agent_type

    if @agent_type.save
      redirect_to @agent_type, notice: t('controller.successfully_created', model: t('activerecord.models.agent_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /agent_types/1
  def update
    if params[:move]
      move_position(@agent_type, params[:move])
      return
    end

    if @agent_type.update(agent_type_params)
      redirect_to @agent_type, notice: t('controller.successfully_updated', model: t('activerecord.models.agent_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /agent_types/1
  def destroy
    @agent_type.destroy
    redirect_to agent_types_url, notice: t('controller.successfully_destroyed', model: t('activerecord.models.agent_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_type
      @agent_type = AgentType.find(params[:id])
      authorize @agent_type
    end

    # Only allow a trusted parameter "white list" through.
    def agent_type_params
      params.require(:agent_type).permit(:name, :display_name, :note)
    end
end
