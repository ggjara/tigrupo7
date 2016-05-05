class AddForeignKeyToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :almacen_id, :integer
  end
end
