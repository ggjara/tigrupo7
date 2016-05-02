class CreateFacturas < ActiveRecord::Migration
  def change
    create_table :facturas do |t|
      t.string :_id
      t.string :proveedor
      t.string :cliente
      t.integer :valorBruto
      t.integer :iva
      t.integer :valorTotal
      t.string :estadoPago
      t.string :id_Oc
      t.string :motivoRechazo
      t.string :motivoAnulacion
      t.timestamps :fechaCreacion
      t.timestamps :fechaUpdate

      t.timestamps null: false
    end
  end
end
