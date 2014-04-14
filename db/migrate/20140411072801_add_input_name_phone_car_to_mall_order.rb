class AddInputNamePhoneCarToMallOrder < ActiveRecord::Migration
  def change
  	add_column :mall_orders, :input_name, :string
  	add_column :mall_orders, :input_phone, :string
  	add_column :mall_orders, :input_car, :integer
  end
end
