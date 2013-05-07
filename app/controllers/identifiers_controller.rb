class IdentifiersController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource
  has_scope :page, :default => 1

  def update
    @identifier = Identifier.find(params[:id])
    if params[:move]
      move_position(@identifier, params[:move])
      return
    end
    update!
  end
end
