class AddAttributesToBodega < ActiveRecord::Migration
  def change
  	add_column :bodegas, :stockGuardadoSku1, :integer, :default => 0
  	add_column :bodegas, :stockGuardadoSku10, :integer, :default => 0
  	add_column :bodegas, :stockGuardadoSku23, :integer, :default => 0
  	add_column :bodegas, :stockGuardadoSku39, :integer, :default => 0
  end
end
