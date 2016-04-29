class AddNameToBodegas < ActiveRecord::Migration
  def change
    add_column :bodegas, :name, :string
  end
end
