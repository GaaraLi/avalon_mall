class MallSku < ActiveRecord::Base
  belongs_to :mall_good
  has_one :mall_inventory
  has_many :mall_shopping_car
end

