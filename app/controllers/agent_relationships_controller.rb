class AgentRelationshipsController < ApplicationController
  before_action :set_agent_relationship, only: [:show, :edit, :update, :destroy]
  before_action :prepare_options, :except => [:index, :destroy]
  after_action :verify_authorized

  # GET /agent_relationships
  def index
    authorize AgentRelationship
    @agent_relationships = AgentRelationship.page(params[:page])
    case
    when @agent
      @agent_relationships = @agent.agent_relationships.order('agent_relationships.position').page(params[:page])
    else
      @agent_relationships = AgentRelationship.page(params[:page])
    end
  end

  # GET /agent_relationships/1
  def show
  end

  # GET /agent_relationships/new
  def new
    @agent_relationship = AgentRelationship.new
    authorize @agent_relationship
    if @agent.blank?
      redirect_to agents_url
      return
    else
      @agent_relationship.agent = @agent
    end
  end

  # GET /agent_relationships/1/edit
  def edit
  end

  # POST /agent_relationships
  def create
    @agent_relationship = AgentRelationship.new(agent_relationship_params)
    authorize @agent_relationship

    if @agent_relationship.save
      redirect_to @agent_relationship, notice: t('controller.successfully_created', model: t('activerecord.models.agent_relationship'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /agent_relationships/1
  def update
    # 並べ替え
    if @agent && params[:move]
      move_position(@agent_relationship, params[:move], false)
      redirect_to agent_relationships_url(agent_id: @agent_relationship.parent_id)
      return
    end
    if @agent_relationship.update(agent_relationship_params)
      redirect_to @agent_relationship, notice: t('controller.successfully_updated', model: t('activerecord.models.agent_relationship'))
    else
      render action: 'edit'
      return
    end
  end

  # DELETE /agent_relationships/1
  def destroy
    @agent_relationship.destroy
    if @agent
      redirect_to agents_url(agent_id: @agent.id), notice: t('controller.successfully_destroyed', model: t('activerecord.models.agent_relationship'))
    else
      redirect_to agent_relationships_url, notice: t('controller.successfully_destroyed', model: t('activerecord.models.agent_relationship'))
    end
  end

  private
  def set_agent_relationship
    @agent_relationship = AgentRelationship.find(params[:id])
    authorize @agent_relationship
  end

  def prepare_options
    @agent_relationship_types = AgentRelationshipType.all
  end

  def agent_relationship_params
    params.require(:agent_relationship).permit(
      :parent_id, :child_id, :agent_relationship_type_id
    )
  end
end
