class ProveedorDespacharProductos < ApplicationController

# Orden:
# 0: Se verifica que la OC fue Aceptada, emitió Factura, Recibio TRX
# 1: Envía los productos
# 2: Por cada producto enviado, se actualiza DB y servidor



def initialize
end


def despacharProductos(oc_id)
	if(validarOcListaParaEnvio(oc_id))
		ordenCompra = Oc.find_by(_id: oc_id)
		return despachoDeProductos(ordenCompra)
	else
		return false
	end
	
end


#Retorna true si la oc fue aceptada
#Factura y TRX realizadas y aun no se despacha
def validarOcListaParaEnvio(oc_id)
	ordenCompra = Oc.find_by(_id: oc_id)

	if ordenCompra==nil
		return false
	end

	if(ordenCompra.estado!='aceptada')
		return false
	end

	if(ordenCompra.facturaRealizadaDB == false)
		return false
	end

	if(ordenCompra.trxRealizadaDB==false)
		return false
	end

	if(ordenCompra.despachadoRealizadoDB == true)
		return false
	end

	return true
end

#Despacha los productos
def despachoDeProductos(oc)
	sku = oc.sku
	cantidad= oc.cantidad.to_i
	clienteId = oc.cliente
	almacenDestino = getAlmacenCliente(clienteId)
	if(almacenDestino==false)
		return false
	end

	#1. Envía todos los que están en almacenDespacho
	cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
	if(cantidad>0)
		#Enviar todos los que están en pulmon a Despacho
		enviarProductosDesdePulmonADespacho(oc, sku, cantidad)
		#envia todos los de Despacho al cliente
		cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
		if(cantidad>0)
			almacenesARevisar = Almacen.where(pulmon: false, recepcion: false, despacho: false)
			while(cantidad>0)
				#3. Envía todos los productos desde los demás almacenes a despacho
				almacenesARevisar.each do |almacen|
					#Envia de un almacen a Despacho
					enviarProductosDesdeAlmacenADespacho(oc, sku, cantidad, almacen)
					#Envia de Despacho a Cliente
					cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
					break if cantidad<=0
					oc.despachadoRealizadoDB=true
					oc.save
					return true
				end
			end
		else
			oc.despachadoRealizadoDB=true
			oc.save
			return true
		end
	else
		oc.despachadoRealizadoDB=true
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
	end

	almacenDespacho = Almacen.find_by(despacho: true)
	
	while(almacenRecepcion.tieneProducto(sku) && almacenDespacho.tieneEspacio(sku)) do
		productoAEnviar = almacenRecepcion.productos.find_by(sku: sku)
		RequestsBodega.new.moverStock(productoAEnviar._id, almacenDespacho._id)
		productoAEnviar.almacen=almacenDespacho
		productoAEnviar.save
		almacenRecepcion.eliminarEspacio
	end	
end

def enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
	almacenDespacho = Almacen.find_by(despacho: true)
	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		productoAEnviar= almacenDespacho.productos.find_by(sku: sku)
		RequestsBodega.new.moverStockBodega(productoAEnviar._id, almacenDestino, oc._id, oc.precioUnitario)
		almacenDespacho.eliminarEspacio
		productoAEnviar.destroy
		cantidad = cantidad - 1
		Bodega.eliminarStockGuardado(sku,1)
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
