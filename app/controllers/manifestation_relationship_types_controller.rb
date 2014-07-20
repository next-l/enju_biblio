class ManifestationRelationshipTypesController < ApplicationController
  before_action :set_manifestation_relationship_type, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized
  after_action :verify_policy_scoped, :only => :index

  # GET /manifestation_relationship_types
  def index
    authorize ManifestationRelationshipType
    @manifestation_relationship_types = policy_scope(ManifestationRelationshipType).order(:position)
  end

  # GET /manifestation_relationship_types/1
  def show
  end

  # GET /manifestation_relationship_types/new
  def new
    @manifestation_relationship_type = ManifestationRelationshipType.new
    authorize @manifestation_relationship_type
  end

  # GET /manifestation_relationship_types/1/edit
  def edit
  end

  # POST /manifestation_relationship_types
  def create
    @manifestation_relationship_type = ManifestationRelationshipType.new(manifestation_relationship_type_params)
    authorize @manifestation_relationship_type

    if @manifestation_relationship_type.save
      redirect_to @manifestation_relationship_type, notice:  t('controller.successfully_created', :model => t('activerecord.models.manifestation_relationship_type'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /manifestation_relationship_types/1
  def update
    if params[:move]
      move_position(@manifestation_relationship_type, params[:move])
      return
    end
    if @manifestation_relationship_type.update(manifestation_relationship_type_params)
      redirect_to @manifestation_relationship_type, notice:  t('controller.successfully_updated', :model => t('activerecord.models.manifestation_relationship_type'))
    else
      render action: 'edit'
    end
  end

  # DELETE /manifestation_relationship_types/1
  def destroy
    @manifestation_relationship_type.destroy
    redirect_to manifestation_relationship_types_url, notice: t('controller.successfully_destroyed', :model => t('activerecord.models.manifestation_relationship_type'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manifestation_relationship_type
      @manifestation_relationship_type = ManifestationRelationshipType.find(params[:id])
      authorize @manifestation_relationship_type
    end

    # Only allow a trusted parameter "white list" through.
    def manifestation_relationship_type_params
      params.require(:manifestation_relationship_type).permit(:name, :display_name, :note)
    end
end
