class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  def get_bottom_ad_without_homepage
    @ad= MallBlock.where('mall_block_type_id= 17').first
    @ad
  end

  helper_method :get_bottom_ad_without_homepage


  private
  def store_location
    if( request.fullpath != "/customers/sign_in" && request.fullpath != "/customers/sign_up" && request.fullpath != "/customers/sign_out" && !request.xhr? )
        fullpath= "http://m.ixiangche.com"+request.fullpath
        cookies[:previous_url] = {
          value: fullpath,
          domain: '.ixiangche.com'
        }
    end
  end
end
