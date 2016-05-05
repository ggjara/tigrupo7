class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :sku
      t.int :total

      t.timestamps null: false
    end
  end
end
