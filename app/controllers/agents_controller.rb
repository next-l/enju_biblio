# -*- encoding: utf-8 -*-
class AgentsController < ApplicationController
  before_action :set_agent, only: [:show, :edit, :update, :destroy]
  before_action :get_work, :get_expression, :get_manifestation, :get_item, :get_agent, :except => [:update, :destroy]
  if defined?(EnjuResourceMerge)
    before_action :get_agent_merge_list, :except => [:create, :update, :destroy]
  end
  before_action :prepare_options, :only => [:new, :edit]
  before_action :store_location
  before_action :get_version, :only => [:show]
  after_action :verify_authorized

  # GET /agents
  # GET /agents.json
  def index
    authorize Agent
    if params[:mode] == 'add'
      unless current_user.try(:has_role?, 'Librarian')
        access_denied; return
      end
    end
    query = params[:query].to_s.strip

    if query.size == 1
      query = "#{query}*"
    end

    @query = query.dup
    query = query.gsub('　', ' ')
    order = nil
    @count = {}

    search = Agent.search(:include => [:agent_type, :required_role])
    search.data_accessor_for(Agent).select = [
      :id,
      :full_name,
      :full_name_transcription,
      :agent_type_id,
      :required_role_id,
      :created_at,
      :updated_at,
      :date_of_birth
    ]
    set_role_query(current_user, search)

    if params[:mode] == 'recent'
      query = "#{query} created_at_d:[NOW-1MONTH TO NOW]"
    end
    unless query.blank?
      search.build do
        fulltext query
      end
    end

    unless params[:mode] == 'add'
      work = @work
      expression = @expression
      manifestation = @manifestation
      agent = @agent
      agent_merge_list = @agent_merge_list
      search.build do
        with(:work_ids).equal_to work.id if work
        with(:expression_ids).equal_to expression.id if expression
        with(:manifestation_ids).equal_to manifestation.id if manifestation
        with(:original_agent_ids).equal_to agent.id if agent
        with(:agent_merge_list_ids).equal_to agent_merge_list.id if agent_merge_list
      end
    end

    role = current_user.try(:role) || Role.default_role
    search.build do
      with(:required_role_id).less_than_or_equal_to role.id
    end

    page = params[:page].to_i || 1
    page = 1 if page == 0
    search.query.paginate(page, Agent.default_per_page)
    @agents = search.execute!.results

    flash[:page_info] = {:page => page, :query => query}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agents }
      format.rss  { render :layout => false }
      format.atom
      format.json { render :json => @agents }
      format.html.phone
    end
  end

  # GET /agents/1
  # GET /agents/1.json
  def show
    case
    when @work
      @agent = @work.creators.find(params[:id])
    when @manifestation
      @agent = @manifestation.publishers.find(params[:id])
    when @item
      @agent = @item.agents.find(params[:id])
    else
      if @version
        @agent = @agent.versions.find(@version).item if @version
      end
    end

    agent = @agent
    role = current_user.try(:role) || Role.default_role
    @works = Manifestation.search do
      with(:creator_ids).equal_to agent.id
      with(:required_role_id).less_than_or_equal_to role.id
      paginate :page => params[:work_list_page], :per_page => Manifestation.default_per_page
    end.results
    @expressions = Manifestation.search do
      with(:contributor_ids).equal_to agent.id
      with(:required_role_id).less_than_or_equal_to role.id
      paginate :page => params[:expression_list_page], :per_page => Manifestation.default_per_page
    end.results
    @manifestations = Manifestation.search do
      with(:publisher_ids).equal_to agent.id
      with(:required_role_id).less_than_or_equal_to role.id
      paginate :page => params[:manifestation_list_page], :per_page => Manifestation.default_per_page
    end.results

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @agent }
      format.js
      format.html.phone
    end
  end

  # GET /agents/new
  # GET /agents/new.json
  def new
    @agent = Agent.new
    authorize @agent
    @agent.required_role = Role.where(:name => 'Guest').first
    @agent.language = Language.where(:iso_639_1 => I18n.default_locale.to_s).first || Language.first
    @agent.country = current_user.library.country
    prepare_options
  end

  # GET /agents/1/edit
  def edit
    prepare_options
  end

  # POST /agents
  # POST /agents.json
  def create
    @agent = Agent.new(agent_params)
    authorize @agent

    respond_to do |format|
      if @agent.save
        case
        when @work
          @agent.works << @work
        when @manifestation
          @agent.manifestations << @manifestation
        when @item
          @agent.items << @item
        end
        format.html { redirect_to @agent, :notice => t('controller.successfully_created', :model => t('activerecord.models.agent')) }
        format.json { render :json => @agent, :status => :created, :location => @agent }
      else
        prepare_options
        format.html { render :action => "new" }
        format.json { render :json => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agents/1
  # PUT /agents/1.json
  def update
    respond_to do |format|
      if @agent.update_attributes(agent_params)
        format.html { redirect_to @agent, :notice => t('controller.successfully_updated', :model => t('activerecord.models.agent')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render :action => "edit" }
        format.json { render :json => @agent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /agents/1
  # DELETE /agents/1.json
  def destroy
    @agent.destroy
    redirect_to agents_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.agent'))
  end

  private
  def set_agent
    @agent = Agent.find(params[:id])
    authorize @agent
  end

  def agent_params
    params.require(:agent).permit(
      :last_name, :middle_name, :first_name,
      :last_name_transcription, :middle_name_transcription,
      :first_name_transcription, :corporate_name, :corporate_name_transcription,
      :full_name, :full_name_transcription, :full_name_alternative,
      :other_designation, :language_id,
      :country_id, :agent_type_id, :note, :required_role_id, :email, :url,
      :full_name_alternative_transcription, :title,
      :agent_identifier
    )
  end

  def prepare_options
    @countries = Country.all_cache
    @agent_types = AgentType.all
    @roles = Role.all
    @languages = Language.all_cache
    @agent_type = AgentType.where(:name => 'Person').first
  end
end
