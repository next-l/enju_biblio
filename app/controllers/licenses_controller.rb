class LicensesController < ApplicationController
  before_action :set_license, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /licenses
  def index
    authorize License
    @licenses = policy_scope(License).order(:position)
  end

  # GET /licenses/1
  def show
  end

  # GET /licenses/new
  def new
    @license = License.new
    authorize @license
  end

  # GET /licenses/1/edit
  def edit
  end

  # POST /licenses
  def create
    @license = License.new(license_params)
    authorize @license

    if @license.save
      redirect_to @license, notice:  t('controller.successfully_created', :model => t('activerecord.models.license'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /licenses/1
  def update
    if params[:move]
      move_position(@license, params[:move])
      return
    end
    if @license.update(license_params)
      redirect_to @license, notice:  t('controller.successfully_updated', :model => t('activerecord.models.license'))
    else
      render action: 'edit'
    end
  end

  # DELETE /licenses/1
  def destroy
    @license.destroy
    redirect_to licenses_url, notice: 'Budget type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_license
      @license = License.find(params[:id])
      authorize @license
    end

    # Only allow a trusted parameter "white list" through.
    def license_params
      params.require(:license).permit(:name, :display_name, :note)
    end
end
