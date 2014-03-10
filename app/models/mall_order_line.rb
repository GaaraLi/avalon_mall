class MallOrderLine < ActiveRecord::Base
	belongs_to :customer
	belongs_to :vendor
	belongs_to :mall_order
	belongs_to :mall_sku
end
