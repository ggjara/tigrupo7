class Almacen < ActiveRecord::Base
	belongs_to :bodega
	has_many :productos, dependent: :destroy


def tieneProducto(sku)
	if self.productos.where(sku: sku).count>0
			return true
	end
	return false
end

end
