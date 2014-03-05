class VendorsController < ApplicationController
	layout 'vendor'
  def index
  end

  def show
    @vendor = Vendor.find(params[:id])
  end

  def map
    @type = params[:type];
    if @type.present?
      @vendors = Vendor.find(:all,:conditions=>["id in (5,21,22,6,23,11,16,24)"]);
    else
      @vendors = Vendor.find(:all,:conditions=>["id != 13 and id !=25"])
    end
    @vendors.reject! { |vendor|
      vendor.address.nil?
    }
    @vendors.reject! { |vendor|
      vendor.address.latitude.nil?
    }
    @vendors = @vendors.to_json(:include => [:address], :methods => :main_photo)
  end

end
