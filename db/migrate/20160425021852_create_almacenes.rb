class CreateAlmacenes < ActiveRecord::Migration
  def change
    create_table :almacenes do |t|

      t.timestamps null: false
    end
  end
end
