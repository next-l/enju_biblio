class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied, :with => :render_403
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  enju_biblio
  enju_library
  enju_inventory

  private
  def render_403
    return if performed?
    if user_signed_in?
      respond_to do |format|
        format.html {render :template => 'page/403', :status => 403}
        format.xml {render :template => 'page/403', :status => 403}
        format.json
      end
    else
      respond_to do |format|
        format.html {redirect_to new_user_session_url}
        format.xml {render :template => 'page/403', :status => 403}
        format.json
      end
    end
  end

  def render_404
    return if performed?
    respond_to do |format|
      format.html {render :template => 'page/404', :status => 404}
      format.mobile {render :template => 'page/404', :status => 404}
      format.xml {render :template => 'page/404', :status => 404}
      format.json
    end
  end

  def access_denied
    raise CanCan::AccessDenied
  end

  def store_location
    if request.get? and request.format.try(:html?) and !request.xhr?
      session[:user_return_to] = request.fullpath
    end
  end

  def solr_commit
    Sunspot.commit
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, request.remote_ip)
  end

  def move_position(resource, direction, redirect = true)
    if ['higher', 'lower'].include?(direction)
      resource.send("move_#{direction}")
      if redirect
        redirect_to url_for(:controller => resource.class.to_s.pluralize.underscore)
        return
      end
    end
  end

  def set_role_query(user, search)
    role = user.try(:role) || Role.default_role
    search.build do
      with(:required_role_id).less_than role.id
    end
  end

  def get_version
    @version = params[:version_id].to_i if params[:version_id]
    @version = nil if @version == 0
  end

  def convert_charset
    case params[:format]
    when 'csv'
      return unless configatron.csv_charset_conversion
      # TODO: 他の言語
      if @locale.to_sym == :ja
        headers["Content-Type"] = "text/csv; charset=Shift_JIS"
        response.body = NKF::nkf('-Ws', response.body)
      end
    when 'xml'
      if @locale.to_sym == :ja
        headers["Content-Type"] = "application/xml; charset=Shift_JIS"
        response.body = NKF::nkf('-Ws', response.body)
      end
    end
  end
end
