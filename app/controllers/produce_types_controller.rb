class ProduceTypesController < ApplicationController
  before_action :set_produce_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /produce_types
  def index
    authorize ProduceType
    @produce_types = policy_scope(ProduceType).order(:position)
  end

  # GET /produce_types/1
  def show
  end

  # GET /produce_types/new
  def new
    @produce_type = ProduceType.new
    authorize @produce_type
  end

  # GET /produce_types/1/edit
  def edit
  end

  # POST /produce_types
  def create
    @produce_type = ProduceType.new(produce_type_params)
    authorize @produce_type

    if @produce_type.save
      redirect_to @produce_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.produce_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /produce_types/1
  def update
    if params[:move]
      move_position(@produce_type, params[:move])
      return
    end
    if @produce_type.update(produce_type_params)
      redirect_to @produce_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.produce_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /produce_types/1
  def destroy
    @produce_type.destroy
    redirect_to produce_types_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.produce_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_produce_type
      @produce_type = ProduceType.find(params[:id])
      authorize @produce_type
    end

    # Only allow a trusted parameter "white list" through.
    def produce_type_params
      params.require(:produce_type).permit(:name, :display_name, :note)
    end
end
