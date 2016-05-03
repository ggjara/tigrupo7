class CreateClientes < ActiveRecord::Migration
  def change
    create_table :clientes do |t|
      t.string :_idGrupo
      t.string :_idBanco
      t.string :_idAlmacenRecepcion

      t.timestamps null: false
    end
  end
end
