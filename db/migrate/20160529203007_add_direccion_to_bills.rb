class AddDireccionToBills < ActiveRecord::Migration
  def change
    add_column :bills, :direccion, :string
  end
end
