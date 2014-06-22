class CarrierTypesController < ApplicationController
  before_action :set_carrier_type, only: [:show, :edit, :update, :destroy]
  before_action :prepare_options, :only => [:new, :edit]
  after_action :verify_authorized

  # GET /carrier_types
  # GET /carrier_types.json
  def index
    authorize CarrierType
    @carrier_types = CarrierType.order(:position)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @carrier_types }
    end
  end

  # GET /carrier_types/1
  # GET /carrier_types/1.json
  def show
  end

  # GET /carrier_types/new
  # GET /carrier_types/new.json
  def new
    @carrier_type = CarrierType.new
    authorize @carrier_type
  end

  # GET /carrier_types/1/edit
  def edit
  end

  # POST /carrier_types
  # POST /carrier_types.json
  def create
    @carrier_type = CarrierType.new(carrier_type_params)
    authorize @carrier_type

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

    if @carrier_type.update(carrier_type_params)
      redirect_to @carrier_type, notice: t('controller.successfully_updated', :model => t('activerecord.models.carrier_type'))
    else
      render :edit
    end
  end

  # DELETE /carrier_types/1
  # DELETE /carrier_types/1.json
  def destroy
    @carrier_type.destroy
    redirect_to carrier_types_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.carrier_type'))
  end

  private
  def set_carrier_type
    @carrier_type = CarrierType.find(params[:id])
    authorize @carrier_type
  end

  def prepare_options
    if defined?(EnjuCirculation)
      @checkout_types = CheckoutType.select([:id, :display_name, :position])
    end
  end

  def carrier_type_params
    params.require(:carrier_type).permit(
      :name, :display_name, :note, :position
    )
  end
end
