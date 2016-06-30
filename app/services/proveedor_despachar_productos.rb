class ProveedorDespacharProductos < ApplicationController

# Orden:
# 0: Se verifica que la OC fue Aceptada, emitió Factura, Recibio TRX
# 1: Envía los productos
# 2: Por cada producto enviado, se actualiza DB y servidor

def initialize
end

def despacharProductos(ordenCompra, esFtp)
	if (ordenCompra==nil)
		puts "xxxORDEN DE COMPRA NULLxxx"
		return false
	else
		if(validarOcListaParaEnvio(ordenCompra, esFtp))
			#Actualiza Bodega
			Bodega.iniciarBodega(false)
			return despachoDeProductos(ordenCompra, esFtp)
		else
			puts "xxxOC invalidaxxx"
			return false
		end
	end
end


#Despacha los productos
def despachoDeProductos(oc, esFtp)
	sku = oc.sku#.sku
	cantidad= oc.cantidad#.cantidad.to_i
	clienteId = oc.cliente#.cliente
	almacenDestino = getAlmacenCliente(clienteId)
	if(almacenDestino==false && !esFtp)
		return false
	end
	#1. Envía todos los que están en almacenDespacho
	cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
	if(cantidad>0)
		otrosAlmacenes = Almacen.where(pulmon: false, despacho: false)
		otrosAlmacenes.each do |otroAlmacen|
			enviarProductosDesdeAlmacenADespacho(sku, otroAlmacen, cantidad)
			cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
			break if cantidad <= 0
		end
		if(cantidad > 0)
			enviarProductosDesdePulmonADespacho(sku, cantidad)
			cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
			if(cantidad>0)
				#Limpiar Recepcion
				vaciarRecepcion
				#Vaciar Pulmon nuevamente
				enviarProductosDesdePulmonADespacho(sku, cantidad)
				cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
				if cantidad>0
					return false
				else
					oc.despachoRealizadoDB =true
					oc.estado = 'finalizada'
					oc.save
					return true
				end
			else
				oc.despachoRealizadoDB =true
				oc.estado = 'finalizada'
				oc.save
				return true
			end
		else
			oc.despachoRealizadoDB=true
			oc.estado = 'finalizada'
			oc.save
			return true
		end
	else
		oc.despachoRealizadoDB=true
		oc.estado = 'finalizada'
		oc.save
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
		puts "[] ALMACEN->DESPACHO: ("<<sku.to_s<<") "<<productoAEnviar._id
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
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
		puts "[] PULMON->RECEPCION: ("<<sku.to_s<<") "<<productoAEnviar._id
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenRecepcion._id)
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

def enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
	almacenDespacho = Almacen.find_by(despacho: true)
	productosGenerados = Array.new
	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		if(productosGenerados.count==0)
			productosGenerados = cargarProductos(sku.to_s, almacenDespacho)
		end
		productoAEnviar = productosGenerados.first
		if(esFtp)
			puts RequestsBodega.new.despacharStock(productoAEnviar._id, 'direccion', oc.precioUnitario, oc._id)
		else
			puts RequestsBodega.new.moverStockBodega(productoAEnviar._id, almacenDestino, oc._id, oc.precioUnitario)
		end
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

#Retorna true si la oc fue aceptada
#Factura y TRX realizadas y aun no se despacha
def validarOcListaParaEnvio(ordenCompra, esFtp)
	if (ordenCompra==nil)
		puts "xxxOC NULLxxx"
		return false
	end

	if(ordenCompra.estado!='aceptada')
		puts "xxxOC NO ACEPTADAxxx"
		return false
	end

	if(ordenCompra.facturaRealizadaDB == false && !esFtp)
		puts "xxxOC SIN FACTURALxxx"
		return false
	end

	if(ordenCompra.trxRealizadaDB==false && !esFtp)
		puts "xxxOC SIN TRXxxx"
		return false
	end

	if(ordenCompra.despachoRealizadoDB == true)
		puts "xxxOC DESPACHADAxxx"
		return false
	end

	puts "---OC VALIDA---"
	return true
end


def getAlmacenCliente(cliente)
	cliente =Cliente.find_by(_idGrupo: cliente)
	if(cliente!=nil)
		return cliente._idAlmacenRecepcion
	else
		return false
	end
end


end
