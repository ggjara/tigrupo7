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
	ordenCompra = Oc.new(RequestsOc.new.obtenerOc(oc_id))
	ordenCompra.estado='aceptada'
	ordenCompra.facturaRealizadaDB = true
	ordenCompra.trxRealizadaDB=true
	ordenCompra.despachoRealizadoDB = false
	ordenCompra.save
	#oc_id = Factura.find_by(_id: factura_id)).id_Oc
	if(validarOcListaParaEnvio(oc_id))
		puts "---OC LISTA PARA ENVIO---"
		#Oc.find_by(_id: oc_id)
		return despachoDeProductos(ordenCompra, esFtp)
	else
		return false
	end

end


#Retorna true si la oc fue aceptada
#Factura y TRX realizadas y aun no se despacha
def validarOcListaParaEnvio(oc_id)

	ordenCompra = Oc.find_by(_id: oc_id)

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
	puts "cantidad"
	puts cantidad
	if(cantidad>0)
		#Enviar todos los que están en pulmon a Despacho
		enviarProductosDesdePulmonADespacho(oc, sku, cantidad)
		#envia todos los de Despacho al cliente
		cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
		if(cantidad>0)
			puts "cantidad"
			puts cantidad
			almacenesARevisar = Almacen.where(pulmon: false, recepcion: false, despacho: false)
			while(cantidad>0)
				puts "cantidad"
				puts cantidad
				#3. Envía todos los productos desde los demás almacenes a despacho
				almacenesARevisar.each do |almacen|
					puts "almacen"
					puts almacen
					#Envia de un almacen a Despacho
					enviarProductosDesdeAlmacenADespacho(oc, sku, cantidad, almacen)
					#Envia de Despacho a Cliente
					cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
					break if cantidad<=0
				end
				oc.despachoRealizadoDB=true
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

def enviarProductosDesdeAlmacenADespacho(oc, sku, cantidad, almacen)
	almacenDespacho = Almacen.find_by(despacho: true)

	while(almacen.tieneProducto(sku) && almacenDespacho.tieneEspacio(sku)) do
		productoAEnviar = almacen.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
		productoAEnviar.almacen= almacenDespacho
		almacen.eliminarEspacio
		puts "producto movido desde almacen a despacho"
	end

end

def enviarProductosDesdePulmonADespacho(oc, sku, cantidad)
	almacenPulmon = Almacen.find_by(pulmon: true)
	almacenRecepcion = Almacen.find_by(recepcion: true)
	while(almacenPulmon.tieneProducto(sku) && almacenRecepcion.tieneEspacio(sku)) do
		productoAEnviar = almacenPulmon.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenRecepcion._id)
		productoAEnviar.almacen = almacenRecepcion
		productoAEnviar.save
		almacenPulmon.eliminarEspacio
		puts "producto movido desde pulmon a recepcion"
	end

	almacenDespacho = Almacen.find_by(despacho: true)

	while(almacenRecepcion.tieneProducto(sku) && almacenDespacho.tieneEspacio(sku)) do
		productoAEnviar = almacenRecepcion.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
		productoAEnviar.almacen=almacenDespacho
		productoAEnviar.save
		almacenRecepcion.eliminarEspacio
		puts "producto movido desde recepcion a despacho"
	end
end

def enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino, esFtp)
	almacenDespacho = Almacen.find_by(despacho: true)
	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		productoAEnviar= almacenDespacho.productos.find_by(sku: sku)
		if(esFtp)
			RequestsBodega.new.despacharStock(productoAEnviar._id, oc.direccion, oc.precioUnitario, oc._id)
		else
			RequestsBodega.new.moverStockBodega(productoAEnviar._id, almacenDestino, oc[:_id], oc[:precioUnitario])
		end
		almacenDespacho.eliminarEspacio
		productoAEnviar.destroy
		cantidad = cantidad - 1
		Bodega.eliminarStockGuardado(sku,1)
		puts "producto movido desde despacho a cliente"
	end

	return cantidad
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
