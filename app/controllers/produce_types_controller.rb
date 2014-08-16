class ProduceTypesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource

  def update
    if params[:move]
      move_position(@produce_type, params[:move])
      return
    end
    update!
  end
end
