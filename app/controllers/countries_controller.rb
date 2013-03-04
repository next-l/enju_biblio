class CountriesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource

  def index
    @countries = Country.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @countries }
    end
  end

  def update
    @country = Country.find(params[:id])
    if params[:move]
      move_position(@country, params[:move])
      return
    end
    update!
  end
end
