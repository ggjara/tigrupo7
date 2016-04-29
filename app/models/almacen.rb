class Almacen < ActiveRecord::Base
	belongs_to :bodega
	has_many :productos, dependent: :destroy
end
