class CreateOcs < ActiveRecord::Migration
  def change
    create_table :ocs do |t|
      t.string :_id
      t.string :cliente
      t.string :proveedor
      t.string :sku
      t.integer :cantidad
      t.integer :cantidadDespachada
      t.integer :precioUnitario
      t.string :canal
      t.string :estado
      t.string :idFactura
      t.datetime :fechaEntrega
      t.string :fechaCreacion
      t.string :notas

      t.timestamps null: false
    end
  end
end
