class CarrierTypesController < ApplicationController
  load_and_authorize_resource
  before_action :prepare_options, :only => [:new, :edit]

  # GET /carrier_types
  # GET /carrier_types.json
  def index
    @carrier_types = CarrierType.order(:position).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @carrier_types }
    end
  end

  # GET /carrier_types/1
  # GET /carrier_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @carrier_type }
    end
  end

  # GET /carrier_types/new
  # GET /carrier_types/new.json
  def new
    @carrier_type = CarrierType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @carrier_type }
    end
  end

  # GET /carrier_types/1/edit
  def edit
  end

  # POST /carrier_types
  # POST /carrier_types.json
  def create
    @carrier_type = CarrierType.new(params[:carrier_type])

    respond_to do |format|
      if @carrier_type.save
        format.html { redirect_to @carrier_type, :notice => t('controller.successfully_created', :model => t('activerecord.models.carrier_type')) }
        format.json { render :json => @carrier_type, :status => :created, :location => @carrier_type }
      else
        prepare_options
        format.html { render :action => "new" }
        format.json { render :json => @carrier_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carrier_types/1
  # PUT /carrier_types/1.json
  def update
    if params[:move]
      move_position(@carrier_type, params[:move])
      return
    end

    respond_to do |format|
      if @carrier_type.update_attributes(params[:carrier_type])
        format.html { redirect_to @carrier_type, :notice => t('controller.successfully_updated', :model => t('activerecord.models.carrier_type')) }
        format.json { head :no_content }
      else
        prepare_options
        format.html { render :action => "edit" }
        format.json { render :json => @carrier_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /carrier_types/1
  # DELETE /carrier_types/1.json
  def destroy
    @carrier_type.destroy

    respond_to do |format|
      format.html { redirect_to carrier_types_url }
      format.json { head :no_content }
    end
  end

  private
  def prepare_options
    if defined?(EnjuCirculation)
      @checkout_types = CheckoutType.select([:id, :display_name, :position])
    end
  end
end
