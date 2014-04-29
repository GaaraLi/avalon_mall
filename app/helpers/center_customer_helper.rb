module CenterCustomerHelper
  def get_order_lines(order_id,status)
  	  if status == 0
  	  	@order_lines = ActiveRecord::Base.connection.select("
		  	select 
		  	    mg.id as mg_id,
				mg.title,
				ms.desc,
				mg.logo_url1,
				v.name as v_name,
				v.id as v_id,
				mol.price,
				mol.quantity
			from 
			mall_order_lines mol
			left join mall_skus ms  on ms.id = mol.mall_sku_id
			left join mall_goods mg on mg.id = ms.mall_good_id
			left join vendors v on v.id = mol.vendor_id
			where mol.mall_order_id = '"+order_id+"'")
	  elsif status == 1
		@order_lines = ActiveRecord::Base.connection.select("
		  	select 
		  		mg.id as mg_id,
				mg.title,
				ms.desc,
				mg.logo_url1,
				v.name as v_name,
				v.id as v_id,
				mol.price,
				1 as quantity,
				me.exchange_code_number,
				me.status,
				me.order_time,
				me.used_time,
				me.id as me_id
			from 
			mall_order_lines mol
			right join mall_exchanges me on mol.id = me.mall_order_line_id
			left join mall_skus ms  on ms.id = mol.mall_sku_id
			left join mall_goods mg on mg.id = ms.mall_good_id
			left join vendors v on v.id = mol.vendor_id
			where mol.mall_order_id = '"+order_id+"'")
		
	  end
	  return @order_lines;
    end
end
