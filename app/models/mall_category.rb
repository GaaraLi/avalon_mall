class MallCategory < ActiveRecord::Base
	has_many :mall_goods
end
