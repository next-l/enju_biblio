class MediumOfPerformancesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, default: 1
  load_and_authorize_resource

  def update
    if params[:move]
      move_position(@medium_of_performance, params[:move])
      return
    end
    update!
  end
end
