class CreateTypesController < ApplicationController
  before_action :set_create_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /create_types
  def index
    authorize CreateType
    @create_types = policy_scope(CreateType).order(:position)
  end

  # GET /create_types/1
  def show
  end

  # GET /create_types/new
  def new
    @create_type = CreateType.new
    authorize @create_type
  end

  # GET /create_types/1/edit
  def edit
  end

  # POST /create_types
  def create
    @create_type = CreateType.new(create_type_params)
    authorize @create_type

    if @create_type.save
      redirect_to @create_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.create_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /create_types/1
  def update
    if params[:move]
      move_position(@create_type, params[:move])
      return
    end
    if @create_type.update(create_type_params)
      redirect_to @create_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.create_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /create_types/1
  def destroy
    @create_type.destroy
    redirect_to create_types_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.create_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_create_type
      @create_type = CreateType.find(params[:id])
      authorize @create_type
    end

    # Only allow a trusted parameter "white list" through.
    def create_type_params
      params.require(:create_type).permit(:name, :display_name, :note)
    end
end
