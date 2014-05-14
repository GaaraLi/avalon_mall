class AddMallOrderColumnCustomerOrderTimes < ActiveRecord::Migration
  def change
  	add_column :mall_orders, :customer_order_times, :string
  end
end
