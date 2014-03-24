class GoodsController < ApplicationController
	def show
      @good = MallGood.find(params[:id])
      @page_title="#{@good.title}"

      @vendor= @good.vendor
      @good_sku= @good.mall_skus

      if (@good_sku[0] && current_customer)
         @good_price= current_customer.get_price(@good_sku[0])
      else
         @good_price= @good.mall_skus.first.customer_price
      end

      @bread_crumbs=[@vendor.name, vendor_path(@vendor.id), @good.title, good_path(@good.id) ]
	end

	def set_sku_info
		sku_id= params[:sku_id]
		@sku= MallSku.find(sku_id)

		render :json=>@sku
	end
end
