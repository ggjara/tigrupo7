class AddAttributesToAlmacen < ActiveRecord::Migration
  def change
    add_column :almacenes, :_id, :string
    add_column :almacenes, :grupo, :integer
    add_column :almacenes, :pulmon, :boolean
    add_column :almacenes, :despacho, :boolean
    add_column :almacenes, :recepcion, :boolean
    add_column :almacenes, :totalSpace, :integer
    add_column :almacenes, :usedSpace, :integer
  end
end
