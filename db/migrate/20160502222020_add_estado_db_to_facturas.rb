class AddEstadoDbToFacturas < ActiveRecord::Migration
  def change
    add_column :facturas, :estadoDB, :string
  end
end
