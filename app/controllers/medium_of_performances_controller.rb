class MediumOfPerformancesController < ApplicationController
  before_action :set_medium_of_performance, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /medium_of_performances
  def index
    authorize MediumOfPerformance
    @medium_of_performances = policy_scope(MediumOfPerformance).order(:position)
  end

  # GET /medium_of_performances/1
  def show
  end

  # GET /medium_of_performances/new
  def new
    @medium_of_performance = MediumOfPerformance.new
    authorize @medium_of_performance
  end

  # GET /medium_of_performances/1/edit
  def edit
  end

  # POST /medium_of_performances
  def create
    @medium_of_performance = MediumOfPerformance.new(medium_of_performance_params)
    authorize @medium_of_performance

    if @medium_of_performance.save
      redirect_to @medium_of_performance, notice:  t('controller.successfully_created', :model => t('activerecord.models.medium_of_performance'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /medium_of_performances/1
  def update
    if params[:move]
      move_position(@medium_of_performance, params[:move])
      return
    end
    if @medium_of_performance.update(medium_of_performance_params)
      redirect_to @medium_of_performance, notice:  t('controller.successfully_updated', :model => t('activerecord.models.medium_of_performance'))
    else
      render action: 'edit'
    end
  end

  # DELETE /medium_of_performances/1
  def destroy
    @medium_of_performance.destroy
    redirect_to medium_of_performances_url, notice: 'Medium of performance was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium_of_performance
      @medium_of_performance = MediumOfPerformance.find(params[:id])
      authorize @medium_of_performance
    end

    # Only allow a trusted parameter "white list" through.
    def medium_of_performance_params
      params.require(:medium_of_performance).permit(:name, :display_name, :note)
    end
end
