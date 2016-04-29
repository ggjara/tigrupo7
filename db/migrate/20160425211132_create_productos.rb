class CreateProductos < ActiveRecord::Migration
  def change
    create_table :productos do |t|
      t.string :_id
      t.integer :grupo
      t.string :almacen
      t.string :sku
      t.string :direccion
      t.float :precio
      t.float :costo

      t.timestamps null: false
    end
  end
end
