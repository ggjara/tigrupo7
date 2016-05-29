class AddFieldsToBills < ActiveRecord::Migration
  def change
  	add_column :bills, :_id, :string
    add_column :bills, :proveedor, :string
    add_column :bills, :cliente, :string
    add_column :bills, :valorBruto, :integer
    add_column :bills, :iva, :integer
    add_column :bills, :valorTotal, :integer
    add_column :bills, :estadoPago, :string
    add_column :bills, :fechaCreacion, :datetime
    add_column :bills, :fechaUpdate, :datetime
    add_column :bills, :id_Oc, :string
  end
end