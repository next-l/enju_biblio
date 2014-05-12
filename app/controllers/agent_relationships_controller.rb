class AgentRelationshipsController < ApplicationController
  before_action :set_agent_relationship, only: [:show, :edit, :update, :destroy]
  before_action :prepare_options, :except => [:index, :destroy]
  after_action :verify_authorized

  # GET /agent_relationships
  def index
    @agent_relationships = AgentRelationship.page(params[:page])
  end

  # GET /agent_relationships/1
  def show
  end

  # GET /agent_relationships/new
  def new
    @agent_relationship = AgentRelationship.new(agent_relationship_params)
    @agent_relationship.parent = Agent.find(params[:agent_id]) rescue nil
    @agent_relationship.child = Agent.find(params[:child_id]) rescue nil
  end

  # GET /agent_relationships/1/edit
  def edit
  end

  # POST /agent_relationships
  def create
    @agent_relationship = AgentRelationship.new(agent_relationship_params)
    authorize @agent_relationship

    if @agent_relationship.save
      redirect_to @agent_relationship, notice:  t('controller.successfully_created', :model => t('activerecord.models.agent_relationship'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /agent_relationships/1
  def update
    if params[:move]
      move_position(@agent_relationship, params[:move])
      return
    end
    if @agent_relationship.update(agent_relationship_params)
      redirect_to @agent_relationship, notice:  t('controller.successfully_updated', :model => t('activerecord.models.agent_relationship'))
    else
      render action: 'edit'
    end
  end

  # DELETE /agent_relationships/1
  def destroy
    @agent_relationship.destroy
    redirect_to agent_relationships_url, notice: 'Agent relationship was successfully destroyed.'
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
