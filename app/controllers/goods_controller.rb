class GoodsController < ApplicationController
	def show
      @good_hot_rec= MallBlock.where("mall_block_type_id=15")
      @good = MallGood.find(params[:id])
      @page_title="#{@good.title}"

      @vendor= @good.vendor
      @vendor_map= @vendor.to_json(:include => [:address], :methods => :main_photo)
      @good_sku= @good.mall_skus

      if (@good_sku[0] && current_customer)
         @good_price= current_customer.get_price(@good_sku[0])
      else
         @good_price= @good.mall_skus.first.customer_price
      end

      @vendor_first_class_cat_id= @good.vendor.mall_goods.map { |g|
         g.mall_category.parent_code
      }.uniq
      @vendor_first_class_cat= @vendor_first_class_cat_id.map{ |c|
        MallCategory.find( c.to_i)
      }

      @bread_crumbs=[@vendor.name, vendor_path(@vendor.id), @good.title, good_path(@good.id) ]

      #此商品是否有限购
      @is_limitation_buy =MallGoodsActivity.where("mall_activity_id = 1 and mall_good_id ="+@good.id.to_s).count;
	end

	def set_sku_info
		sku_id= params[:sku_id]
		@sku= MallSku.find(sku_id)

		render :json=>@sku, :include=>:mall_inventory
	end
end
