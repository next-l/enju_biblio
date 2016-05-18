class PeriodicalsController < ApplicationController
  before_action :set_periodical, only: [:show, :edit, :update, :destroy]

  # GET /periodicals
  def index
    @periodicals = Periodical.all
  end

  # GET /periodicals/1
  def show
  end

  # GET /periodicals/new
  def new
    @periodical = Periodical.new
  end

  # GET /periodicals/1/edit
  def edit
  end

  # POST /periodicals
  def create
    @periodical = Periodical.new(periodical_params)

    if @periodical.save
      redirect_to @periodical, notice: 'Periodical was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /periodicals/1
  def update
    if @periodical.update(periodical_params)
      redirect_to @periodical, notice: 'Periodical was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /periodicals/1
  def destroy
    @periodical.destroy
    redirect_to periodicals_url, notice: 'Periodical was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_periodical
      @periodical = Periodical.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def periodical_params
      params.require(:periodical).permit(:original_title, :manifestation_id, :frequency_id)
    end
end
