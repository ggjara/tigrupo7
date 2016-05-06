class AddFechaCreacionToTrxes < ActiveRecord::Migration
  def change
    add_column :trxes, :fechaCreacion, :timestamps
  end
end
