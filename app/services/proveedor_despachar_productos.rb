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
		despachoDeProductos(ordenCompra)
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

	if(ordenCompra.estado!='aceptada' && ordenCompra.estadoDB!='aceptada')
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
	proveedor = oc.proveedor
	almacenDestino = getAlmacenProveedor(proveedor)
	if(almacenDestino==false)
		return false
	end


	#1. Envía todos los que están en almacenDespacho
	cantidad = enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
	if(cantidad>0)
		return cantidad.to_i
	end
	#2. Envía todos los que están en pulmon a despacho
	#2.1 Envía todos los que están en despacho
	#3 Envía todos los que están en recepcion a despacho
	#3.1 Envía todos los que están en desapacho
	#4. Envía todos los que están en un almacen a despacho
	#4.1 Envía todos los que están en despacho
	#5. Repetir punto 4 hasta que se manden todos
	#6. Enviar true cuando se manden todos

	
end

def enviarProductosDesdeDespacho(oc, sku, cantidad, almacenDestino)
	almacenDespacho = Almacen.find_by(despacho: true)
	productosDespacho = almacenDespacho.productos.where(sku: sku)


	while (cantidad>0 && almacenDespacho.tieneProducto(sku)) do
		productoAEnviar= almacenDespacho.productos.find_by(sku: sku)
		# RequestsBodega.new.moverStockBodega(productoAEnviar._id, 
		# 	almacenDestino, oc._id, oc.precioUnitario)
		productoAEnviar.destroy
		cantidad = cantidad -1
		Bodega.eliminarStockGuardado(sku,1)
	end

	return cantidad
end


def getAlmacenProveedor(proveedor)
	return '571262aaa980ba030058a147'
	# if (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'		
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# elsif (proveedor=='codigogrupo1')
	# 	return 'almacenrecepciongrupo1'
	# else
	# 	return false
end


end
