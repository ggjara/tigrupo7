class ProveedorDespacharProductosBoleta < ApplicationController

# Orden:
# 0: Se verifica que los parametros sean validos
# 1: Envía los productos
# 2: Por cada producto enviado, se actualiza DB y servidor

def initialize
end

def despacharProductos(sku, cantidad, direccion, boleta)
	if(validarEnvio(sku, cantidad, direccion, boleta))
		precio = boleta.valorTotal / cantidad
		id = boleta._id
		#Actualiza Bodega
		Bodega.iniciarBodega(false)
		return despachoDeProductos(sku, cantidad, direccion, precio, id)
	else
		return false
	end
end


#Despacha los productos
def despachoDeProductos(sku, cantidad, direccion, precio, id)
	#1. Envía todos los que están en almacenDespacho
	cantidad = enviarProductosDesdeDespacho(sku, cantidad, direccion, precio, id)
	if(cantidad>0)
		otrosAlmacenes = Almacen.where(pulmon: false, despacho: false)
		otrosAlmacenes.each do |otroAlmacen|
			enviarProductosDesdeAlmacenADespacho(sku, otroAlmacen, cantidad)
			cantidad = enviarProductosDesdeDespacho(sku, cantidad, direccion, precio, id)
			break if cantidad <= 0
		end
		if(cantidad > 0)
			enviarProductosDesdePulmonADespacho(sku, cantidad)
			cantidad = enviarProductosDesdeDespacho(sku, cantidad, direccion, precio, id)
			if(cantidad>0)
				#Limpiar Recepcion
				vaciarRecepcion
				#Vaciar Pulmon nuevamente
				enviarProductosDesdePulmonADespacho(sku, cantidad)
				cantidad = enviarProductosDesdeDespacho(sku, cantidad, direccion, precio, id)
				if cantidad>0
					return false
				else
					return true
				end
			else
				return true
			end
		else
			return true
		end
	else
		return true
	end
end

def cargarProductos(sku, almacen)
	productosGenerados = Array.new
	paramsProductos = RequestsBodega.new.getStock(almacen._id, sku.to_s, 200)
	paramsProductos.each do |paramsProducto|
       productoCreado = Producto.new(paramsProducto)
       productoCreado.save
       productosGenerados.append(productoCreado)
    end
    return productosGenerados
end

def cargarProductosCualquiera(almacen)
	productosGenerados = Array.new
	stocksPillado = almacen.stocks.where('total > 0')
	if stocksPillado.count > 0
		sku = stocksPillado.first.sku
		paramsProductos = RequestsBodega.new.getStock(almacen._id, sku, 200)
		paramsProductos.each do |paramsProducto|
	       productoCreado = Producto.new(paramsProducto)
	       productoCreado.save
	       productosGenerados.append(productoCreado)
	    end
	    return productosGenerados
	else
		return productosGenerados
	end
end

def enviarProductosDesdeAlmacenADespacho(sku, almacen, cantidad)
	almacenDespacho = Almacen.find_by(despacho: true)
	cantidadMovida = 0
	productosGenerados = Array.new
	while(almacen.tieneProducto(sku) && almacenDespacho.tieneEspacio(1)) do
		if(productosGenerados.count==0)
			productosGenerados = cargarProductos(sku, almacen)
		end
		productoAEnviar = productosGenerados.first
		puts RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
		productosGenerados.delete(productoAEnviar)
		almacen.eliminarStock(sku.to_s)
		almacenDespacho.agregarStock(sku.to_s)
		almacen.eliminarEspacio(1)
		almacenDespacho.agregarEspacio(1)
		cantidadMovida = cantidadMovida + 1
		break if cantidadMovida >= cantidad
	end
end

def enviarProductosDesdePulmonADespacho(sku, cantidad)
	almacenPulmon = Almacen.find_by(pulmon: true)
	almacenRecepcion = Almacen.find_by(recepcion: true)
	cantidadMovidaDesdePulmon=0
	productosGenerados = Array.new
	while(almacenPulmon.tieneProducto(sku) && almacenRecepcion.tieneEspacio(1)) do
		if(productosGenerados.count==0)
			productosGenerados = cargarProductos(sku, almacenPulmon)
		end
		productoAEnviar = productosGenerados.first
		puts RequestsBodega.new.moverStock(productoAEnviar._id, almacenRecepcion._id)
		productosGenerados.delete(productoAEnviar)
		almacenPulmon.eliminarStock(sku.to_s)
		almacenRecepcion.agregarStock(sku.to_s)
		almacenPulmon.eliminarEspacio(1)
		almacenRecepcion.agregarEspacio(1)
		cantidadMovidaDesdePulmon = cantidadMovidaDesdePulmon +1
		break if cantidadMovidaDesdePulmon >= cantidad
	end
	enviarProductosDesdeAlmacenADespacho(sku, almacenRecepcion, cantidad)
end

def enviarProductosDesdeDespacho(sku, cantidad, direccion, precio, id)
	almacenDespacho = Almacen.find_by(despacho: true)
	productosGenerados = Array.new
	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		if(productosGenerados.count==0)
			productosGenerados = cargarProductos(sku.to_s, almacenDespacho)
		end
		productoAEnviar = productosGenerados.first

		puts RequestsBodega.new.despacharStock(productoAEnviar._id, direccion, precio, id)

		productosGenerados.delete(productoAEnviar)
		almacenDespacho.eliminarStock(sku.to_s)
		almacenDespacho.eliminarEspacio(1)
		Bodega.eliminarStockGuardado(sku,1)
		cantidad = cantidad - 1
	end
	return cantidad
end

def vaciarRecepcion
	almacenRecepcion = Almacen.find_by(recepcion: true)
	almacenesOtros = Almacen.where(pulmon: false, recepcion: false, despacho: false)
	productosGenerados = Array.new
	almacenesOtros.each do |almacenQueRecibe|
		while (almacenRecepcion.tieneProductos && almacenQueRecibe.tieneEspacio(1)) do
			if(productosGenerados.count==0)
				productosGenerados = cargarProductosCualquiera(almacenRecepcion)
			end
			break if productosGenerados.count==0
			productoAEnviar = productosGenerados.first
			puts RequestsBodega.new.moverStock(productoAEnviar._id, almacenQueRecibe._id)
			productosGenerados.delete(productoAEnviar)
			almacenRecepcion.eliminarStock(productoAEnviar.sku.to_s)
			almacenQueRecibe.agregarStock(productoAEnviar.sku.to_s)
			almacenRecepcion.eliminarEspacio(1)
			almacenQueRecibe.agregarEspacio(1)
		end
	end
end

def vaciarDespacho
	almacenDespacho = Almacen.find_by(despacho: true)
	almacenesOtros = Almacen.where(pulmon: false, recepcion: false, despacho: false)
	productosGenerados = Array.new
	almacenesOtros.each do |almacenQueRecibe|
		while (almacenDespacho.tieneProductos && almacenQueRecibe.tieneEspacio(1)) do
			if(productosGenerados.count==0)
				productosGenerados = cargarProductosCualquiera(almacenDespacho)
			end
			break if productosGenerados.count==0
			productoAEnviar = productosGenerados.first
			RequestsBodega.new.moverStock(productoAEnviar._id, almacenQueRecibe._id)
			productosGenerados.delete(productoAEnviar)
			almacenDespacho.eliminarStock(productoAEnviar.sku.to_s)
			almacenQueRecibe.agregarStock(productoAEnviar.sku.to_s)
			almacenDespacho.eliminarEspacio(1)
			almacenQueRecibe.agregarEspacio(1)
		end
	end
end

#Factura y TRX realizadas y aun no se despacha
def validarEnvio(sku, cantidad, direccion, boletaId)
	if (sku==nil)
		return false
	end

	if (cantidad==nil || cantidad <=0)
		return false
	end

	if (direccion==nil)
		return false
	end

	if (boletaId==nil)
		return false
	end

	return true
end

end


