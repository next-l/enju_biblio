class ManifestationRelationshipsController < ApplicationController
  before_action :set_manifestation_relationship, only: [:show, :edit, :update, :destroy]
  before_action :prepare_options, :except => [:index, :destroy]
  after_action :verify_authorized

  # GET /manifestation_relationships
  def index
    authorize ManifestationRelationship
    @manifestation_relationships = ManifestationRelationship.page(params[:page])
  end

  # GET /manifestation_relationships/1
  def show
  end

  # GET /manifestation_relationships/new
  def new
    @manifestation_relationship = ManifestationRelationship.new
    authorize @manifestation_relationship
    @manifestation_relationship.parent = Manifestation.find(params[:manifestation_id]) rescue nil
    @manifestation_relationship.child = Manifestation.find(params[:child_id]) rescue nil
  end

  # GET /manifestation_relationships/1/edit
  def edit
  end

  # POST /manifestation_relationships
  def create
    @manifestation_relationship = ManifestationRelationship.new(manifestation_relationship_params)
    authorize @manifestation_relationship

    if @manifestation_relationship.save
      redirect_to @manifestation_relationship, notice:  t('controller.successfully_created', :model => t('activerecord.models.manifestation_relationship'))
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /manifestation_relationships/1
  def update
    if params[:move]
      move_position(@manifestation_relationship, params[:move])
      return
    end
    if @manifestation_relationship.update(manifestation_relationship_params)
      redirect_to @manifestation_relationship, notice:  t('controller.successfully_updated', :model => t('activerecord.models.manifestation_relationship'))
    else
      render action: 'edit'
    end
  end

  # DELETE /manifestation_relationships/1
  def destroy
    @manifestation_relationship.destroy
    redirect_to manifestation_relationships_url, notice: 'Manifestation relationship was successfully destroyed.'
  end

  private
  def set_manifestation_relationship
    @manifestation_relationship = ManifestationRelationship.find(params[:id])
    authorize @manifestation_relationship
  end

  def prepare_options
    @manifestation_relationship_types = ManifestationRelationshipType.all
  end

  def manifestation_relationship_params
    params.require(:manifestation_relationship).permit(
      :parent_id, :child_id, :manifestation_relationship_type_id
    )
  end
end
