class VendorsController < ApplicationController
	layout 'vendor'
  def index
  end

  def show
    @vendor = Vendor.find(params[:id])
  end
end
