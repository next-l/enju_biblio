class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /countries
  def index
    authorize Country
    @countries = policy_scope(Country).order(:position)
  end

  # GET /countries/1
  def show
  end

  # GET /countries/new
  def new
    @country = Country.new
    authorize @country
  end

  # GET /countries/1/edit
  def edit
  end

  # POST /countries
  def create
    @country = Country.new(country_params)
    authorize @country

    if @country.save
      redirect_to @country, notice:  t('controller.successfully_created', :model => t('activerecord.models.country'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /countries/1
  def update
    if params[:move]
      move_position(@country, params[:move])
      return
    end
    if @country.update(country_params)
      redirect_to @country, notice:  t('controller.successfully_updated', :model => t('activerecord.models.country'))
    else
      render action: 'edit'
    end
  end

  # DELETE /countries/1
  def destroy
    @country.destroy
    redirect_to countries_url, notice: 'Content type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_country
      @country = Country.find(params[:id])
      authorize @country
    end

    # Only allow a trusted parameter "white list" through.
    def country_params
      params.require(:country).permit(
        :name, :display_name, :alpha_2, :alpha_3, :numeric_3, :note
      )
    end
end
