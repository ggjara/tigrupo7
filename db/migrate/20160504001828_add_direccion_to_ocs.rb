class AddDireccionToOcs < ActiveRecord::Migration
  def change
    add_column :ocs, :direccion, :string
  end
end
