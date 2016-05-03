class Almacen < ActiveRecord::Base
	belongs_to :bodega
	has_many :productos, dependent: :destroy


def tieneEspacio(sku)
	if (self.totalSpace - self.usedSpace)> espacio(sku)
		return true
	else
		return false
	end
end

def tieneProducto(sku)
	if self.productos.where(sku: sku).count>0
		return true
	end
	return false
end

def eliminarEspacio
	self.usedSpace = self.usedSpace - 1
	self.save
end


def espacio(sku)		
	return 1
end

end
