class AddCustomerOrderTimes < ActiveRecord::Migration
  def change
  	add_column :customers, :customer_order_times, :string
  end
end
