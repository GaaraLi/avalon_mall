class MallSku < ActiveRecord::Base
  belongs_to :mall_good
  has_one :mall_inventory
end

