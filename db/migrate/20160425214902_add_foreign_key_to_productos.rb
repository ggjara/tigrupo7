class AddForeignKeyToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :almacen_id, :integer
  end
end
