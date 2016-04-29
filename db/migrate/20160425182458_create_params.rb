class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :name
      t.string :value

      t.timestamps null: false
    end
  end
end
