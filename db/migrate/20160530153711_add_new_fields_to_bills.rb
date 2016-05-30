class AddNewFieldsToBills < ActiveRecord::Migration
  def change
    add_column :bills, :sku, :string
    add_column :bills, :cantidad, :integer
  end
end
