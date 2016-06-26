class CreateInfosaldos < ActiveRecord::Migration
  def change
    create_table :infosaldos do |t|
      t.datetime :fecha
      t.integer :cantidad

      t.timestamps null: false
    end
  end
end
