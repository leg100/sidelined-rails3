class ApplicationController < ActionController::Base
  protect_from_forgery

  # https://github.com/plataformatec/devise/wiki/How-To:-Redirect-back-to-current-page-after-sign-in,-sign-out,-sign-up,-update
  after_filter :store_location

  def store_location
    logger.debug("Request: #{request.fullpath}")
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath 
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  # security risk: will return a now-guest user to possible secure page
  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end
end
