module ApplicationHelper
	def set_title_tag
		site_name= "享车商城"
		title= @page_title ? "#{@page_title} | #{site_name}": "#{site_name}"
		content_tag("title", title, nil, false)
	end

	def drop_bread_crumb
		@bread_crumbs_html=""
		@bread_crumbs_html << "<a href= #{root_path} >首页 </a>"
		@bread_crumbs.each_slice(2).each do |b|
			if b[0]
				@bread_crumbs_html << "&nbsp&nbsp>&nbsp&nbsp"
				@bread_crumbs_html << "<a href= #{b[1]}> #{b[0]} </a>"
			end

		end
		return @bread_crumbs_html.html_safe
	end

    def get_footer_info
      @footer_info= MallBlock.where("mall_block_type_id=16")
    end

    def get_search_flag
    	@flag=0
    end

    def get_shopping_car_qty
      @shopping_car_qty= 0
      if current_customer
        @shopping_car_goods=MallShoppingCar.where("customer_id=#{current_customer.id}")
        @shopping_car_goods.each do |g|
          if g.quantity != 0 && !g.quantity.nil?
            @shopping_car_qty = g.quantity + @shopping_car_qty
            puts g.quantity
          end
        end
      end
      @shopping_car_qty
    end

    def get_rank_info
    	@good_sale_rank= MallSku.order("sale_count DESC").limit(5)
    end

    def get_goods_qty (goods_id)
      @count = ActiveRecord::Base.connection.select("select  ifnull(sum(inventory_qty),0) as sum_qty from mall_inventories where mall_sku_id in (select id from mall_skus where mall_good_id="+goods_id.to_s+")")
      return @count[0]["sum_qty"]
    end

end
