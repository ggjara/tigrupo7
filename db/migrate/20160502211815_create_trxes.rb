class CreateTrxes < ActiveRecord::Migration
  def change
    create_table :trxes do |t|
      t.string :_id
      t.string :cuentaOrigen
      t.string :cuentaDestino
      t.float :monto

      t.timestamps null: false
    end
  end
end
