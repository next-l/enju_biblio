class FrequenciesController < ApplicationController
  before_action :set_frequency, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /frequencies
  def index
    authorize Frequency
    @frequencies = policy_scope(Frequency).order(:position)
  end

  # GET /frequencies/1
  def show
  end

  # GET /frequencies/new
  def new
    @frequency = Frequency.new
    authorize @frequency
  end

  # GET /frequencies/1/edit
  def edit
  end

  # POST /frequencies
  def create
    @frequency = Frequency.new(frequency_params)
    authorize @frequency

    if @frequency.save
      redirect_to @frequency, notice:  t('controller.successfully_created', :model => t('activerecord.models.frequency'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /frequencies/1
  def update
    if params[:move]
      move_position(@frequency, params[:move])
      return
    end
    if @frequency.update(frequency_params)
      redirect_to @frequency, notice:  t('controller.successfully_updated', :model => t('activerecord.models.frequency'))
    else
      render action: 'edit'
    end
  end

  # DELETE /frequencies/1
  def destroy
    @frequency.destroy
    redirect_to frequencies_url, :notice => t('controller.successfully_destroyed', :model => t('activerecord.models.frequency'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_frequency
      @frequency = Frequency.find(params[:id])
      authorize @frequency
    end

    # Only allow a trusted parameter "white list" through.
    def frequency_params
      params.require(:frequency).permit(:name, :display_name, :note)
    end
end
