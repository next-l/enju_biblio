class ContentTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource

  def index
    @content_types = ContentType.page(params[:page])
  end

  def update
    @content_type = ContentType.find(params[:id])
    if params[:move]
      move_position(@content_type, params[:move])
      return
    end
    update!
  end
end
