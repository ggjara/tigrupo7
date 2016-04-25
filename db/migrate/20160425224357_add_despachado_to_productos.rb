class AddDespachadoToProductos < ActiveRecord::Migration
  def change
    add_column :productos, :despachado, :boolean
  end
end
