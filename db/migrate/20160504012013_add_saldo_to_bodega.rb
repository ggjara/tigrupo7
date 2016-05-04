class AddSaldoToBodega < ActiveRecord::Migration
  def change
  	add_column :bodegas, :saldo, :integer
  end
end
