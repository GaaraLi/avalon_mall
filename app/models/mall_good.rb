class MallGood < ActiveRecord::Base
	belongs_to :mall_area
	belongs_to :mall_category
	belongs_to :vendor
	has_many :mall_skus
	has_many :mall_goods_properties
end

