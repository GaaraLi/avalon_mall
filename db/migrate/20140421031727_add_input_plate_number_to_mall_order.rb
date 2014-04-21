class AddInputPlateNumberToMallOrder < ActiveRecord::Migration
  def change
  	add_column :mall_orders, :input_plate_number, :string
  end
end
