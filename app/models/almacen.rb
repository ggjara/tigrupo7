class Almacen < ActiveRecord::Base
	belongs_to :bodega
	has_many :productos, dependent: :destroy


def tieneEspacio(cantidad)
	if (self.totalSpace - self.usedSpace)> cantidad
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

def eliminarEspacio(cantidad)
	self.usedSpace = self.usedSpace - cantidad
	self.save
end

def agregarEspacio(cantidad)
	self.usedSpace = self.usedSpace - cantidad
	self.save
end


def espacio(sku)		
	return 1
end

end
