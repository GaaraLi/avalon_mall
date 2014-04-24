class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  private
  def store_location
    if( request.fullpath != "/customers/sign_in" && request.fullpath != "/customers/sign_up" && !request.xhr? )
        fullpath= "http://m.ixiangche.com"+request.fullpath
        cookies[:previous_url] = {
          value: fullpath,
          domain: '.ixiangche.com'
        }
    end
  end
end
