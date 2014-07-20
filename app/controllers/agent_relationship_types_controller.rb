class AgentRelationshipTypesController < ApplicationController
  before_action :set_agent_relationship_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /agent_relationship_types
  def index
    authorize AgentRelationshipType
    @agent_relationship_types = policy_scope(AgentRelationshipType).order(:position)
  end

  # GET /agent_relationship_types/1
  def show
  end

  # GET /agent_relationship_types/new
  def new
    @agent_relationship_type = AgentRelationshipType.new
    authorize @agent_relationship_type
  end

  # GET /agent_relationship_types/1/edit
  def edit
  end

  # POST /agent_relationship_types
  def create
    @agent_relationship_type = AgentRelationshipType.new(agent_relationship_type_params)
    authorize @agent_relationship_type

    if @agent_relationship_type.save
      redirect_to @agent_relationship_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.agent_relationship_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /agent_relationship_types/1
  def update
    if params[:move]
      move_position(@agent_relationship_type, params[:move])
      return
    end
    if @agent_relationship_type.update(agent_relationship_type_params)
      redirect_to @agent_relationship_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.agent_relationship_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /agent_relationship_types/1
  def destroy
    @agent_relationship_type.destroy
    redirect_to agent_relationship_types_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.agent_relationship_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agent_relationship_type
      @agent_relationship_type = AgentRelationshipType.find(params[:id])
      authorize @agent_relationship_type
    end

    # Only allow a trusted parameter "white list" through.
    def agent_relationship_type_params
      params.require(:agent_relationship_type).permit(:name, :display_name, :note)
    end
end
