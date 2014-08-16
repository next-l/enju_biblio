class AgentRelationshipTypesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource

  def update
    @agent_relationship_type = AgentRelationshipType.find(params[:id])
    if params[:move]
      move_position(@agent_relationship_type, params[:move])
      return
    end
    update!
  end
end
