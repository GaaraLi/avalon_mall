class CreateMallShoppingCars < ActiveRecord::Migration
  def change
    create_table :mall_shopping_cars do |t|
      t.decimal :price,:precision => 10, :scale => 2
      t.decimal :original_price,:precision => 10, :scale => 2
      t.integer :quantity
      t.integer :mall_sku_id
      t.integer :vendor_id
      t.integer :customer_id

      t.timestamps
    end
  end
end
