class AddGrupoToClientes < ActiveRecord::Migration
  def change
    add_column :clientes, :grupo, :integer
  end
end
