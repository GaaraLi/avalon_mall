class AddOrderTimeToMallExchange < ActiveRecord::Migration
  def change
  	add_column :mall_exchanges, :order_time, :string , :after=>"mall_order_line_id"
  end
end
