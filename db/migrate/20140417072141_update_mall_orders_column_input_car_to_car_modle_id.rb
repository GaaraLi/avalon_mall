class UpdateMallOrdersColumnInputCarToCarModleId < ActiveRecord::Migration
  def change
  	rename_column :mall_orders, :input_car, :car_model_id
  end
end
