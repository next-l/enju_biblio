class OwnsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_agent, :get_item
  after_filter :solr_commit, :only => [:create, :update, :destroy]

  # GET /owns
  # GET /owns.json
  def index
    if @agent
      @owns = @agent.owns.order('owns.position').page(params[:page])
    elsif @item
      @owns = @item.owns.order('owns.position').page(params[:page])
    else
      @owns = Own.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @owns }
    end
  end

  # GET /owns/1
  # GET /owns/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @own }
    end
  end

  # GET /owns/new
  def new
    if @item and @agent.blank?
      redirect_to item_agents_url(@item)
      return
    elsif @agent and @item.blank?
      redirect_to agent_items_url(@agent)
      return
    else
      @own = Own.new
      @own.item = @item
      @own.agent = @agent
    end
  end

  # GET /owns/1/edit
  def edit
  end

  # POST /owns
  # POST /owns.json
  def create
    @own = Own.new(params[:own])

    respond_to do |format|
      if @own.save
        format.html { redirect_to @own, :notice => t('controller.successfully_created', :model => t('activerecord.models.own')) }
        format.json { render :json => @own, :status => :created, :location => @own }
      else
        format.html { render :action => "new" }
        format.json { render :json => @own.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /owns/1
  # PUT /owns/1.json
  def update
    if @item and params[:move]
      move_position(@own, params[:move], false)
      redirect_to owns_url(item_id: @own.item_id)
      return
    end

    respond_to do |format|
      if @own.update_attributes(params[:own])
        format.html { redirect_to @own, :notice => t('controller.successfully_updated', :model => t('activerecord.models.own')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @own.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /owns/1
  # DELETE /owns/1.json
  def destroy
    @own.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = t('controller.successfully_deleted', :model => t('activerecord.models.own'))
        case
        when @agent
          redirect_to agent_owns_url(@agent)
        when @item
          redirect_to item_owns_url(@item)
        else
          redirect_to owns_url
        end
      }
      format.json { head :no_content }
    end
  end
end
