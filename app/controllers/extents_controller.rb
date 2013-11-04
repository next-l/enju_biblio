class ExtentsController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource

  def index
    @extents = Extent.page(params[:page])
  end

  def update
    @extent = Extent.find(params[:id])
    if params[:move]
      move_position(@extent, params[:move])
      return
    end
    update!
  end
end
