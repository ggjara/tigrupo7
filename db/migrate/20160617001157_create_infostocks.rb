class CreateInfostocks < ActiveRecord::Migration
  def change
    create_table :infostocks do |t|
      t.datetime :fecha
      t.integer :cantidadTotal
      t.integer :cantidadDisponible

      t.timestamps null: false
    end
  end
end
