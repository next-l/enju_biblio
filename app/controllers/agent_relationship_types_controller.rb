class AgentRelationshipTypesController < ApplicationController
  load_and_authorize_resource
  # GET /agent_relationship_types
  # GET /agent_relationship_types.json
  def index
    @agent_relationship_types = AgentRelationshipType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agent_relationship_types }
    end
  end

  # GET /agent_relationship_types/1
  # GET /agent_relationship_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agent_relationship_type }
    end
  end

  # GET /agent_relationship_types/new
  # GET /agent_relationship_types/new.json
  def new
    @agent_relationship_type = AgentRelationshipType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agent_relationship_type }
    end
  end

  # GET /agent_relationship_types/1/edit
  def edit
  end

  # POST /agent_relationship_types
  # POST /agent_relationship_types.json
  def create
    @agent_relationship_type = AgentRelationshipType.new(params[:agent_relationship_type])

    respond_to do |format|
      if @agent_relationship_type.save
        format.html { redirect_to @agent_relationship_type, notice: t('controller.successfully_created', model: t('activerecord.models.agent_relationship_type')) }
        format.json { render json: @agent_relationship_type, status: :created, location: @agent_relationship_type }
      else
        format.html { render action: "new" }
        format.json { render json: @agent_relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agent_relationship_types/1
  # PUT /agent_relationship_types/1.json
  def update
    if params[:move]
      move_position(@agent_relationship_type, params[:move])
      return
    end

    respond_to do |format|
      if @agent_relationship_type.update_attributes(params[:agent_relationship_type])
        format.html { redirect_to @agent_relationship_type, notice: t('controller.successfully_updated', model: t('activerecord.models.agent_relationship_type')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agent_relationship_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agent_relationship_types/1
  # DELETE /agent_relationship_types/1.json
  def destroy
    @agent_relationship_type.destroy

    respond_to do |format|
      format.html { redirect_to agent_relationship_types_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.agent_relationship_type')) }
      format.json { head :no_content }
    end
  end

  private
  def agent_relationship_type_params
    params.require(:agent_relationship_type).permit(:name, :display_name, :note)
  end
end
