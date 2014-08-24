class AgentMergeListsController < ApplicationController
  load_and_authorize_resource

  # GET /agent_merge_lists
  # GET /agent_merge_lists.json
  def index
    @agent_merge_lists = AgentMergeList.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agent_merge_lists }
    end
  end

  # GET /agent_merge_lists/1
  # GET /agent_merge_lists/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agent_merge_list }
    end
  end

  # GET /agent_merge_lists/new
  # GET /agent_merge_lists/new.json
  def new
    @agent_merge_list = AgentMergeList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agent_merge_list }
    end
  end

  # GET /agent_merge_lists/1/edit
  def edit
  end

  # POST /agent_merge_lists
  # POST /agent_merge_lists.json
  def create
    @agent_merge_list = AgentMergeList.new(params[:agent_merge_list])

    respond_to do |format|
      if @agent_merge_list.save
        flash[:notice] = t('controller.successfully_created', model: t('activerecord.models.agent_merge_list'))
        format.html { redirect_to(@agent_merge_list) }
        format.json { render json: @agent_merge_list, status: :created, location: @agent_merge_list }
      else
        format.html { render action: "new" }
        format.json { render json: @agent_merge_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agent_merge_lists/1
  # PUT /agent_merge_lists/1.json
  def update
    respond_to do |format|
      if @agent_merge_list.update_attributes(params[:agent_merge_list])
        if params[:mode] == 'merge'
          selected_agent = Agent.where(id: params[:selected_agent_id]).first
          if selected_agent
            @agent_merge_list.merge_agents(selected_agent)
            flash[:notice] = t('merge_list.successfully_merged', model: t('activerecord.models.agent'))
          else
            flash[:notice] = t('merge_list.specify_id', model: t('activerecord.models.agent'))
            redirect_to agent_merge_list_url(@agent_merge_list)
            return
          end
        else
          flash[:notice] = t('controller.successfully_updated', model: t('activerecord.models.agent_merge_list'))
        end
        format.html { redirect_to(@agent_merge_list) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agent_merge_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agent_merge_lists/1
  # DELETE /agent_merge_lists/1.json
  def destroy
    @agent_merge_list.destroy

    respond_to do |format|
      format.html { redirect_to(agent_merge_lists_url) }
      format.json { head :no_content }
    end
  end
end
