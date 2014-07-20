class ExtentsController < ApplicationController
  before_action :set_extent, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /extents
  def index
    authorize Extent
    @extents = policy_scope(Extent).order(:position)
  end

  # GET /extents/1
  def show
  end

  # GET /extents/new
  def new
    @extent = Extent.new
    authorize @extent
  end

  # GET /extents/1/edit
  def edit
  end

  # POST /extents
  def create
    @extent = Extent.new(extent_params)
    authorize @extent

    if @extent.save
      redirect_to @extent, notice:  t('controller.successfully_created', :model => t('activerecord.models.extent'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /extents/1
  def update
    if params[:move]
      move_position(@extent, params[:move])
      return
    end
    if @extent.update(extent_params)
      redirect_to @extent, notice:  t('controller.successfully_updated', :model => t('activerecord.models.extent'))
    else
      render action: 'edit'
    end
  end

  # DELETE /extents/1
  def destroy
    @extent.destroy
    redirect_to extents_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.extent'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extent
      @extent = Extent.find(params[:id])
      authorize @extent
    end

    # Only allow a trusted parameter "white list" through.
    def extent_params
      params.require(:extent).permit(:name, :display_name, :note)
    end
end
