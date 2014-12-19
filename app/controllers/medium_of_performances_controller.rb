class MediumOfPerformancesController < ApplicationController
  load_and_authorize_resource
  # GET /medium_of_performances
  # GET /medium_of_performances.json
  def index
    @medium_of_performances = MediumOfPerformance.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @medium_of_performances }
    end
  end

  # GET /medium_of_performances/1
  # GET /medium_of_performances/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @medium_of_performance }
    end
  end

  # GET /medium_of_performances/new
  # GET /medium_of_performances/new.json
  def new
    @medium_of_performance = MediumOfPerformance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @medium_of_performance }
    end
  end

  # GET /medium_of_performances/1/edit
  def edit
  end

  # POST /medium_of_performances
  # POST /medium_of_performances.json
  def create
    @medium_of_performance = MediumOfPerformance.new(params[:medium_of_performance])

    respond_to do |format|
      if @medium_of_performance.save
        format.html { redirect_to @medium_of_performance, notice:  t('controller.successfully_created', model:  t('activerecord.models.medium_of_performance')) }
        format.json { render json: @medium_of_performance, status: :created, location: @medium_of_performance }
      else
        format.html { render action: "new" }
        format.json { render json: @medium_of_performance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /medium_of_performances/1
  # PUT /medium_of_performances/1.json
  def update
    if params[:move]
      move_position(@medium_of_performance, params[:move])
      return
    end

    respond_to do |format|
      if @medium_of_performance.update_attributes(params[:medium_of_performance])
        format.html { redirect_to @medium_of_performance, notice:  t('controller.successfully_updated', model:  t('activerecord.models.medium_of_performance')) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @medium_of_performance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medium_of_performances/1
  # DELETE /medium_of_performances/1.json
  def destroy
    @medium_of_performance.destroy

    respond_to do |format|
      format.html { redirect_to medium_of_performances_url, notice: t('controller.successfully_deleted', model: t('activerecord.models.medium_of_performance')) }
      format.json { head :no_content }
    end
  end

  private
  def medium_of_performance_params
    params.require(:medium_of_performance).permit(:name, :display_name, :note)
  end
end
