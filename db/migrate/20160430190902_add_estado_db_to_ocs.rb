class AddEstadoDbToOcs < ActiveRecord::Migration
  def change
  	add_column :ocs, :estadoDB, :string, :default => ''
  end
end
