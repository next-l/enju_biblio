class ProduceTypesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @produce_types = ProduceType.page(params[:page])
  end

  def update
    @produce_type = ProduceType.find(params[:id])
    if params[:move]
      move_position(@produce_type, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :produce_type => [:name, :display_name, :note]
    )
  end
end
