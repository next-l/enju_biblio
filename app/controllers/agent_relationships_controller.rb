class AgentRelationshipsController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: [:index, :create]
  authorize_resource only: [:index, :create]
  before_action :prepare_options, :except => [:index, :destroy]

  def index
    @agent_relationships = AgentRelationship.page(params[:page])
  end

  def new
    @agent_relationship = AgentRelationship.new(params[:agent_relationship])
    @agent_relationship.parent = Agent.find(params[:agent_id]) rescue nil
    @agent_relationship.child = Agent.find(params[:child_id]) rescue nil
  end

  def update
    @agent_relationship = AgentRelationship.find(params[:id])
    if params[:move]
      move_position(@agent_relationship, params[:move])
      return
    end
    update!
  end

  private
  def prepare_options
    @agent_relationship_types = AgentRelationshipType.all
  end

  def permitted_params
    params.permit(
      :agent_relationship => [
        :parent_id, :child_id, :agent_relationship_type_id
      ]
    )
  end
end
