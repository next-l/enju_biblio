class AgentTypesController < ApplicationController
  load_and_authorize_resource
  # GET /agent_types
  # GET /agent_types.json
  def index
    @agent_types = AgentType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agent_types }
    end
  end

  # GET /agent_types/1
  # GET /agent_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agent_type }
    end
  end

  # GET /agent_types/new
  # GET /agent_types/new.json
  def new
    @agent_type = AgentType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agent_type }
    end
  end

  # GET /agent_types/1/edit
  def edit
  end

  # POST /agent_types
  # POST /agent_types.json
  def create
    @agent_type = AgentType.new(params[:agent_type])

    respond_to do |format|
      if @agent_type.save
        format.html { redirect_to @agent_type, notice:  t('controller.successfully_created', model:  t('activerecord.models.agent_type')) }
        format.json { render json: @agent_type, status: :created, location: @agent_type }
      else
        format.html { render action: "new" }
        format.json { render json: @agent_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agent_types/1
  # PUT /agent_types/1.json
  def update
    if params[:move]
      move_position(@agent_type, params[:move])
      return
    end

    respond_to do |format|
      if @agent_type.update_attributes(params[:agent_type])
        format.html { redirect_to @agent_type, notice:  t('controller.successfully_updated', model:  t('activerecord.models.agent_type')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agent_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agent_types/1
  # DELETE /agent_types/1.json
  def destroy
    @agent_type.destroy

    respond_to do |format|
      format.html { redirect_to agent_types_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.agent_type')) }
      format.json { head :no_content }
    end
  end
end
