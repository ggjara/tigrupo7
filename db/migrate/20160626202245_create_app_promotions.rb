class CreateAppPromotions < ActiveRecord::Migration
  def change
    create_table :app_promotions do |t|
      t.string :sku
      t.integer :precio
      t.datetime :fechaInicio
      t.datetime :fechaTermino
      t.string :codigo

      t.timestamps null: false
    end
  end
end
