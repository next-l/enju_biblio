class FrequenciesController < InheritedResources::Base
  respond_to :html, :json
  has_scope :page, :default => 1
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @frequencies = Frequency.page(params[:page])
  end

  def update
    if params[:move]
      move_position(@frequency, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :frequency => [:name, :display_name, :note]
    )
  end
end
