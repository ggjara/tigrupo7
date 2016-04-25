class AddForeignKeyToAlmacenes < ActiveRecord::Migration
  def change
    add_column :almacenes, :bodega_id, :integer
  end
end
