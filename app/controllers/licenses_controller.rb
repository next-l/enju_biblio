class LicensesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource

  def update
    if params[:move]
      move_position(@license, params[:move])
      return
    end
    update!
  end
end
