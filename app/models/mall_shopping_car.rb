class MallShoppingCar < ActiveRecord::Base
	belongs_to :customer
	belongs_to :mall_sku
end
