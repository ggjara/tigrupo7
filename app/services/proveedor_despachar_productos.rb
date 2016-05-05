class ProveedorDespacharProductos < ApplicationController

# Orden:
# 0: Se verifica que la OC fue Aceptada, emitió Factura, Recibio TRX
# 1: Envía los productos
# 2: Por cada producto enviado, se actualiza DB y servidor



def initialize
end


def despacharProductos(factura_id, esFtp)
	#solo en version prueba
	oc_id = RequestsFactura.new.obtenerFactura(factura_id)[:id_Oc]
	#ordenCompra= Oc.find_by(_id: oc_id)
	ordenCompra = Oc.new(RequestsOc.new.obtenerOc(oc_id))
	ordenCompra.estado='aceptada'
	ordenCompra.facturaRealizadaDB = true
	ordenCompra.trxRealizadaDB=true
	ordenCompra.despachoRealizadoDB = false
	ordenCompra.save
	if ordenCompra==nil
		return false
	else
		if(validarOcListaParaEnvio(ordenCompra))
			puts "---OC LISTA PARA ENVIO---"
			return despachoDeProductos(ordenCompra, esFtp)
		else
			return false
		end
	end
end


#Despacha los productos
def despachoDeProductos(oc, esFtp)
	sku = oc[:sku]#.sku
	cantidad= oc[:cantidad]#.cantidad.to_i
	clienteId = oc[:cliente]#.cliente
	almacenDestino = getAlmacenCliente(clienteId)
	if(almacenDestino==false)
		return false
	end

	#1. Envía todos los que están en almacenDespacho
	cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
	if(cantidad>0)
		#2. Envía todos los de los demás almacenes
		otrosAlmacenes = Almacen.where(pulmon: false, despacho: false)
		otrosAlmacenes.each do |otroAlmacen| 
			enviarProductosDesdeAlmacenADespacho(sku, otroAlmacen, cantidad)
			cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
			break if cantidad <= 0
		end
		if(cantidad > 0)
			#Envia desde Pulmon a Despacho y de Ahí para afuera
			enviarProductosDesdePulmonADespacho(oc, sku, cantidad)
			cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
			if(cantidad>0)
				#Limpiar Recepcion
				#Vaciar Pulmon nuevamente
				return false
			else
				oc.despachoRealizadoDB =true
				oc.save
				return true
			end
		else
			oc.despachoRealizadoDB=true
			oc.save
			return true
		end
	else
		oc.despachoRealizadoDB=true
		oc.save
		return true
	end	
end

def enviarProductosDesdeAlmacenADespacho(sku, almacen, cantidad)
	almacenDespacho = Almacen.find_by(despacho: true)
	cantidadMovida = 0 
	while(almacen.tieneProducto(sku) && almacenDespacho.tieneEspacio(1)) do
		productoAEnviar = almacen.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
		productoAEnviar.almacen= almacenDespacho
		productoAEnviar.save
		almacen.eliminarEspacio(1)
		almacenDespacho.agregarEspacio(1)
		cantidadMovida = cantidadMovida+!
		break if cantidadMovida > cantidad
	end
end

def enviarProductosDesdePulmonADespacho(sku, cantidad)
	almacenPulmon = Almacen.find_by(pulmon: true)
	almacenRecepcion = Almacen.find_by(recepcion: true)
	cantidadMovidaDesdePulmon=0
	while(almacenPulmon.tieneProducto(sku) && almacenRecepcion.tieneEspacio(1)) do
		productoAEnviar = almacenPulmon.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenRecepcion._id)
		productoAEnviar.almacen = almacenRecepcion
		productoAEnviar.save
		almacenPulmon.eliminarEspacio(1)
		almacenRecepcion.agregarEspacio(1)
		cantidadMovida = cantidadMovida+!
		break if cantidadMovidaDesdePulmon > cantidad
	end
	enviarProductosDesdeAlmacenADespacho(sku, almacenRecepcion, cantidad)
end

def enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
	almacenDespacho = Almacen.find_by(despacho: true)
	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		productoAEnviar= almacenDespacho.productos.find_by(sku: sku)
		if(esFtp)
			RequestsBodega.new.despacharStock(productoAEnviar._id, oc.direccion, oc.precioUnitario, oc._id)
		else
			RequestsBodega.new.moverStockBodega(productoAEnviar._id, almacenDestino, oc._id, oc.precioUnitario)
		end
		productoAEnviar.destroy
		almacenDespacho.eliminarEspacio(1)
		Bodega.eliminarStockGuardado(sku,1)
		cantidad = cantidad - 1
	end
	return cantidad
end

#Retorna true si la oc fue aceptada
#Factura y TRX realizadas y aun no se despacha
def validarOcListaParaEnvio(ordenCompra)

	if (ordenCompra==nil)
		puts "xxxOC NULLxxx"
		return false
	end

	if(ordenCompra.estado!='aceptada')
		puts "xxxOC NO ACEPTADAxxx"
		return false
	end

	if(ordenCompra.facturaRealizadaDB == false)
		puts "xxxOC SIN FACTURALxxx"
		return false
	end

	if(ordenCompra.trxRealizadaDB==false)
		puts "xxxOC SIN TRXxxx"
		return false
	end

	if(ordenCompra.despachoRealizadoDB == true)
		puts "xxxOC DESPACHADAxxx"
		return false
	end

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
