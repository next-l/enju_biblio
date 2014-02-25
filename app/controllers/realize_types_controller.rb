class RealizeTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @realize_types = RealizeType.page(params[:page])
  end

  def update
    @realize_type = RealizeType.find(params[:id])
    if params[:move]
      move_position(@realize_type, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :realize_type => [:name, :display_name, :note]
    )
  end
end
