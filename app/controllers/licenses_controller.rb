class LicensesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource

  def index
    @licenses = License.page(params[:page])
  end

  def update
    if params[:move]
      move_position(@license, params[:move])
      return
    end
    update!
  end
end
