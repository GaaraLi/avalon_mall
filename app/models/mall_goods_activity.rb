class MallGoodsActivity < ActiveRecord::Base
	belongs_to :mall_activity
	belongs_to :mall_good
end
