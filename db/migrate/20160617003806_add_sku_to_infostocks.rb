class AddSkuToInfostocks < ActiveRecord::Migration
  def change
    add_column :infostocks, :sku, :string
  end
end
