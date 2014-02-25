class LicensesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

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

  private
  def permitted_params
    params.permit(
      :license => [:name, :display_name, :note]
    )
  end
end
