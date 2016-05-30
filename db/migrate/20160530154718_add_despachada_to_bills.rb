class AddDespachadaToBills < ActiveRecord::Migration
  def change
    add_column :bills, :despachada, :boolean, default: false 
  end
end
