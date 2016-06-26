class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.string :sku
      t.integer :prize

      t.timestamps null: false
    end
  end
end
