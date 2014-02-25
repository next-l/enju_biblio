# -*- encoding: utf-8 -*-
class SeriesStatementsController < ApplicationController
  load_and_authorize_resource except: [:index, :create]
  authorize_resource only: [:index, :create]
  before_action :get_manifestation, :except => [:create, :update, :destroy]
  after_action :solr_commit, :only => [:create, :update, :destroy]
  if defined?(EnjuResourceMerge)
    before_action :get_series_statement_merge_list, :except => [:create, :update, :destroy]
  end

  # GET /series_statements
  # GET /series_statements.json
  def index
    search = Sunspot.new_search(SeriesStatement)
    query = params[:query].to_s.strip
    page = params[:page] || 1

    unless query.blank?
      @query = query.dup
      query = query.gsub('　', ' ')
    end
    search.build do
      fulltext query if query.present?
      paginate :page => page.to_i, :per_page => SeriesStatement.default_per_page
      order_by :position, :asc
    end
    #work = @work
    manifestation = @manifestation
    series_statement_merge_list = @series_statement_merge_list
    search.build do
      with(:manifestation_id).equal_to manifestation.id if manifestation
      with(:series_statement_merge_list_ids).equal_to series_statement_merge_list.id if series_statement_merge_list
    end
    page = params[:page] || 1
    search.query.paginate(page.to_i, SeriesStatement.default_per_page)
    search_result = search.execute!
    @series_statements = search_result.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @series_statements }
    end
  end

  # GET /series_statements/1
  # GET /series_statements/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @series_statement }
      #format.js
      #format.mobile
    end
  end

  # GET /series_statements/new
  # GET /series_statements/new.json
  def new
    @series_statement = SeriesStatement.new
  end

  # GET /series_statements/1/edit
  def edit
  end

  # POST /series_statements
  # POST /series_statements.json
  def create
    @series_statement = SeriesStatement.new(series_statement_params)
    manifestation = Manifestation.find(@series_statement.manifestation_id) rescue nil

    respond_to do |format|
      if @series_statement.save
        @series_statement.manifestations << manifestation if manifestation
        format.html { redirect_to @series_statement, :notice => t('controller.successfully_created', :model => t('activerecord.models.series_statement')) }
        format.json { render :json => @series_statement, :status => :created, :location => @series_statement }
      else
        @frequencies = Frequency.all
        format.html { render :action => "new" }
        format.json { render :json => @series_statement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /series_statements/1
  # PUT /series_statements/1.json
  def update
    if params[:move]
      move_position(@series_statement, params[:move])
      return
    end

    respond_to do |format|
      if @series_statement.update_attributes(series_statement_params)
        format.html { redirect_to @series_statement, :notice => t('controller.successfully_updated', :model => t('activerecord.models.series_statement')) }
        format.json { head :no_content }
      else
        @frequencies = Frequency.all
        format.html { render :action => "edit" }
        format.json { render :json => @series_statement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /series_statements/1
  # DELETE /series_statements/1.json
  def destroy
    @series_statement.destroy

    respond_to do |format|
      format.html { redirect_to series_statements_url }
      format.json { head :no_content }
    end
  end

  def series_statement_params
    params.require(:series_statement).permit(
      :original_title, :numbering, :title_subseries,
      :numbering_subseries, :title_transcription, :title_alternative,
      :series_statement_identifier, :note,
      :root_manifestation_id, :url,
      :title_subseries_transcription, :creator_string, :volume_number_string,
      :series_master
    )
  end
end
