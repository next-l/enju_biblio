class ManifestationRelationshipTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource

  def update
    if params[:move]
      move_position(@manifestation_relationship_type, params[:move])
      return
    end
    update!
  end
end
