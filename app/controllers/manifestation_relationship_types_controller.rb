class ManifestationRelationshipTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @manifestation_relationship_types = ManifestationRelationshipType.page(params[:page])
  end

  def update
    if params[:move]
      move_position(@manifestation_relationship_type, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :manifestation_relationship_type => [:name, :display_name, :note]
    )
  end
end
