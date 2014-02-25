class LanguagesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource except: :create
  authorize_resource only: :create

  def index
    @languages = Language.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @languages }
    end
  end

  def update
    if params[:move]
      move_position(@language, params[:move])
      return
    end
    update!
  end

  private
  def permitted_params
    params.permit(
      :language => [
        :name, :native_name, :display_name, :iso_639_1, :iso_639_2, :iso_639_3,
        :note
      ]
    )
  end
end
