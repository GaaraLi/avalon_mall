class CreateMallExchanges < ActiveRecord::Migration
  def change
    create_table :mall_exchanges do |t|
      t.string :exchange_code_number
      t.integer :status, :default=> 0
      t.integer :mall_order_line_id

      t.timestamps
    end
  end
end
