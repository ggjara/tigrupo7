class CreatePizzas < ActiveRecord::Migration
  def change
    create_table :pizzas do |t|

      t.timestamps null: false
    end
  end
end
