class MallOrder < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :customer
  has_many   :mall_order_lines
end
