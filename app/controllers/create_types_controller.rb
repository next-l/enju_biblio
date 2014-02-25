class CreateTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @create_types = CreateType.page(params[:page])
  end

  def update
    @create_type = CreateType.find(params[:id])
    if params[:move]
      move_position(@create_type, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :create_type => [:name, :display_name, :note]
    )
  end
end
