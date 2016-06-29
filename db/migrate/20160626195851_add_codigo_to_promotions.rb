class AddCodigoToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :codigo, :string
  end
end
