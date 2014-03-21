class GoodsController < ApplicationController
	def show
      @good = MallGood.find(params[:id])
      @page_title="#{@good.title}"

      @vendor= @good.vendor
      @bread_crumbs=[@vendor.name, vendor_path(@vendor.id), @good.title, good_path(@good.id) ]
	end
end
