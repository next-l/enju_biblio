class AgentTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource

  def index
    @agent_types = AgentType.page(params[:page])
  end

  def update
    @agent_type = AgentType.find(params[:id])
    if params[:move]
      move_position(@agent_type, params[:move])
      return
    end
    update!
  end
end
