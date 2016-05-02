class AddAttributesToOcs < ActiveRecord::Migration
  def change
    add_column :ocs, :trxDB, :string
    add_column :ocs, :facturaDB, :string
    add_column :ocs, :facturaRealizadaDB, :boolean, :default => false
    add_column :ocs, :trxRealizadaDB, :boolean, :default => false
    add_column :ocs, :despachoRealizadoDB, :boolean, :default => false
  end
end