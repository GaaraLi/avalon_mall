class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  private
  def store_location
    if( request.fullpath != "/customers/login" && request.fullpath != "/customers/sign_up" && !request.xhr? )
        cookies[:previous_url] = {
          value: request.url,
          domain: '.ixiangche.com'
        }
    end
  end
end
