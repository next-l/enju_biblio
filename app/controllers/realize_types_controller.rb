class RealizeTypesController < ApplicationController
  before_action :set_realize_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /realize_types
  def index
    authorize RealizeType
    @realize_types = policy_scope(RealizeType).order(:position)
  end

  # GET /realize_types/1
  def show
  end

  # GET /realize_types/new
  def new
    @realize_type = RealizeType.new
    authorize @realize_type
  end

  # GET /realize_types/1/edit
  def edit
  end

  # POST /realize_types
  def create
    @realize_type = RealizeType.new(realize_type_params)
    authorize @realize_type

    if @realize_type.save
      redirect_to @realize_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.realize_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /realize_types/1
  def update
    if params[:move]
      move_position(@realize_type, params[:move])
      return
    end
    if @realize_type.update(realize_type_params)
      redirect_to @realize_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.realize_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /realize_types/1
  def destroy
    @realize_type.destroy
    redirect_to realize_types_url, notice: 'Budget type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_realize_type
      @realize_type = RealizeType.find(params[:id])
      authorize @realize_type
    end

    # Only allow a trusted parameter "white list" through.
    def realize_type_params
      params.require(:realize_type).permit(:name, :display_name, :note)
    end
end
