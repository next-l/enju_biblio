class ExtentsController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, default: 1
  load_and_authorize_resource

  def update
    if params[:move]
      move_position(@extent, params[:move])
      return
    end
    update!
  end
end
