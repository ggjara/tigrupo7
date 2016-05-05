class Almacen < ActiveRecord::Base
	belongs_to :bodega
	has_many :productos, dependent: :destroy
	has_many :stocks, dependent: :destroy


def tieneEspacio(cantidad)
	if (self.totalSpace - self.usedSpace)> cantidad
		return true
	else
		return false
	end
end

def tieneProducto(sku)
	stockBuscado = self.stocks.find_by(sku: sku)
	if stockBuscado != nil
		if stockBuscado.total>0
			return true
		end
	end
	return false
end


def tieneProductos
	stocksBuscados = self.stocks
	stocksBuscados.each do |st|
		if st.total>0
			return true
		end
	end

	return false
end

def eliminarStock(sku)
	stockBuscado = self.stocks.find_by(sku: sku)
	if stockBuscado != nil
		stockBuscado.total = stockBuscado.total - 1
		stockBuscado.save
		self.save
	else
		return false
	end
end


def lala
	puts 'holi'
end

def agregarStock(sku)
	stockBuscado = self.stocks.find_by(sku: sku)
	if stockBuscado != nil
		stockBuscado.total = stockBuscado.total + 1
		stockBuscado.save
		self.save
	else
		nuevoStock = Stock.new(sku: sku.to_s, total: 1)
		nuevoStock.almacen = self
		nuevoStock.save
		self.save
	end
end

def eliminarEspacio(cantidad)
	self.usedSpace = self.usedSpace - cantidad
	self.save
end

def agregarEspacio(cantidad)
	self.usedSpace = self.usedSpace + cantidad
	self.save
end


def espacio(sku)		
	return 1
end

end
