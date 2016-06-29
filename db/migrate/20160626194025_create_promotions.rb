class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :sku
      t.integer :precio
      t.datetime :fechaInicio
      t.datetime :fechaTermino

      t.timestamps null: false
    end
  end
end
