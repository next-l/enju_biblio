module ItemsHelper
  def filtered_params
    params.permit([:view, :format, :page, :library, :carrier_type, :reservable, :pub_date_from, :pub_date_until, :language, :sort_by, :per_page])
  end
end
