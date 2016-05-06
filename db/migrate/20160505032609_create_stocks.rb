class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :sku
      t.integer :total
    end
  end
end
