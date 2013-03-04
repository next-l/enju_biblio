class LanguagesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource

  def index
    @languages = Language.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @languages }
    end
  end

  def update
    @language = Language.find(params[:id])
    if params[:move]
      move_position(@language, params[:move])
      return
    end
    update!
  end
end
