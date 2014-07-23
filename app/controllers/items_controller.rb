# -*- encoding: utf-8 -*-
class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :get_agent, :get_manifestation, :get_shelf, :except => [:create, :update, :destroy]
  if defined?(EnjuInventory)
    before_action :get_inventory_file
  end
  before_action :get_library, :get_item, :except => [:create, :update, :destroy]
  before_action :prepare_options, :only => [:new, :edit]
  before_action :get_version, :only => [:show]
  after_action :verify_authorized
  after_action :convert_charset, :only => :index

  # GET /items
  # GET /items.json
  def index
    authorize Item
    query = params[:query].to_s.strip
    per_page = Item.default_per_page
    @count = {}
    if user_signed_in?
      if current_user.has_role?('Librarian')
        if params[:format] == 'txt'
          per_page = 65534
        elsif params[:mode] == 'barcode'
          per_page = 40
        end
      end
    end

    if defined?(InventoryFile)
      if @inventory_file
        if user_signed_in?
          if current_user.has_role?('Librarian')
            case params[:inventory]
            when 'not_in_catalog'
              mode = 'not_in_catalog'
            else
              mode = 'not_on_shelf'
            end
            order = 'items.id'
            @items = Item.inventory_items(@inventory_file, mode).order(order).page(params[:page]).per(per_page)
          else
            access_denied
            return
          end
        else
          redirect_to new_user_session_url
          return
        end
      end
    end

    if params[:query].to_s.strip == ''
      user_query = '*'
    else
      user_query = params[:query]
    end

    if user_signed_in?
      role_ids = Role.where('id <= ?', current_user.role.id).pluck(:id)
    else
      role_ids = [1]
    end

    unless @inventory_file
      @query = params[:query]
      query = {
        query: {
          filtered: {
            query: {
              query_string: {
                query: user_query, fields: ['_all']
              }
            }
          }
        },
        sort: {
          created_at: 'desc'
        }
      }

      unless params[:mode] == 'add'
        query[:query][:filtered][:query][:term] = {agent_id: @agent.id} if @agent
        query[:query][:filtered][:query][:term] = {manifestation_id: @manifestation.id} if @manifestation
        query[:query][:filtered][:query][:term] = {shelf_id: @shelf.id} if @shelf
      end

      if params[:acquired_from].present?
        begin
          acquired_from = Time.zone.parse(params[:acquired_from]).beginning_of_day
          @acquired_from = acquired_from.strftime('%Y-%m-%d')
        rescue ArgumentError
        rescue NoMethodError
        end
      end
      if params[:acquired_to].present?
        begin
          acquired_to = @acquired_to = Time.zone.parse(params[:acquired_to]).end_of_day
          @acquired_to = acquired_to.strftime('%Y-%m-%d')
        rescue ArgumentError
        rescue NoMethodError
        end
      end
      search.build do
        with(:acquired_at).greater_than_or_equal_to acquired_from.beginning_of_day if acquired_from
        with(:acquired_at).less_than acquired_to.tomorrow.beginning_of_day if acquired_to
      end

      page = params[:page] || 1
      search = Item.search(query, routing: role_ids)
      @items = search.page(params[:page]).records
      @count[:total] = @items.total_entries
    end

    if defined?(EnjuBarcode)
      if params[:mode] == 'barcode'
        render :action => 'barcode', :layout => false
        return
      end
    end

    flash[:page_info] = {:page => page, :query => query}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
      format.txt  { render :layout => false }
      format.atom
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  # GET /items/new.json
  def new
    @item = Item.new
    authorize @item
    if Shelf.real.blank?
      flash[:notice] = t('item.create_shelf_first')
      redirect_to libraries_url
      return
    end
    unless @manifestation
      flash[:notice] = t('item.specify_manifestation')
      redirect_to manifestations_url
      return
    end
    @item.shelf = @library.shelves.first
    @item.manifestation = @manifestation
    if defined?(EnjuCirculation)
      @circulation_statuses = CirculationStatus.where(
        :name => [
          'In Process',
          'Available For Pickup',
          'Available On Shelf',
          'Claimed Returned Or Never Borrowed',
          'Not Available']
      ).order(:position)
      @item.circulation_status = CirculationStatus.where(name: 'In Process').first
      @item.checkout_type = @manifestation.carrier_type.checkout_types.first
      @item.item_has_use_restriction = ItemHasUseRestriction.new
      @item.item_has_use_restriction.use_restriction = UseRestriction.where(:name => 'Not For Loan').first
    end
  end

  # GET /items/1/edit
  def edit
    if @manifestation
      @item.manifestation = @manifestation
    end
    @item.library_id = @item.shelf.library_id
    if defined?(EnjuCirculation)
      unless @item.use_restriction
        @item.build_item_has_use_restriction
        @item.item_has_use_restriction.use_restriction = UseRestriction.where(:name => 'Not For Loan').first
      end
    end
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    authorize @item
    manifestation = Manifestation.find(@item.manifestation_id)

    respond_to do |format|
      if @item.save
        @item.manifestation = manifestation
        Item.transaction do
          if defined?(EnjuCirculation)
            if @item.reserved?
              flash[:message] = t('item.this_item_is_reserved')
              @item.retain(current_user)
            end
          end
        end
        format.html { redirect_to(@item, notice: t('controller.successfully_created', :model => t('activerecord.models.item'))) }
        format.json { render :json => @item, :status => :created, :location => @item }
      else
        prepare_options
        format.html { render action: 'new' }
        format.json { render json: @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update_attributes(item_params)
        format.html { redirect_to @item, notice: t('controller.successfully_updated', :model => t('activerecord.models.item')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy

    flash[:notice] = t('controller.successfully_destroyed', :model => t('activerecord.models.item'))
    if @item.manifestation
      redirect_to items_url(manifestation_id: @item.manifestation_id), notice: t('controller.successfully_destroyed', :model => t('activerecord.models.item'))
    else
      redirect_to items_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.item'))
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
    authorize @item
  end

  def prepare_options
    @libraries = Library.real << Library.web
    if @item
      if @item.new_record?
        @library = Library.real.order(:position).includes(:shelves).first
      else
        @library = @item.shelf.library
      end
    else
      @library = Library.real.order(:position).includes(:shelves).first
    end
    @shelves = @library.shelves
    @bookstores = Bookstore.all
    @budget_types = BudgetType.all
    @roles = Role.all
    if defined?(EnjuCirculation)
      @circulation_statuses = CirculationStatus.all
      @use_restrictions = UseRestriction.available
      if @manifestation
        @checkout_types = CheckoutType.available_for_carrier_type(@manifestation.carrier_type)
      else
        @checkout_types = CheckoutType.all
      end
    end
  end

  def item_params
    params.require(:item).permit(
      :call_number, :item_identifier, :circulation_status_id,
      :checkout_type_id, :shelf_id, :include_supplements, :note, :url, :price,
      :acquired_at, :bookstore_id, :missing_since, :budget_type_id,
      :lock_version, :manifestation_id, :library_id, :required_role_id #,
      # :exemplify_attributes
    )
  end
end
