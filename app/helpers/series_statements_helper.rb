module SeriesStatementsHelper
  include ManifestationsHelper

  def series_pagination_link
    if flash[:manifestation_id]
      render 'manifestations/paginate_id_link', manifestation: Manifestation.find(flash[:manifestation_id])
    end
  end

  def filtered_params
    params.permit([:locale, :format, :page, :per_page])
  end
end
