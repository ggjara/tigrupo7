class AddContadoresToBodegas < ActiveRecord::Migration
  def change
    add_column :bodegas, :cantAlmacenes, :integer
    add_column :bodegas, :cantProductos, :integer
  end
end
