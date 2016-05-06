class ProducirProductosProcesados < ApplicationController

def initialize
end

#1. Se verifica que estén las condiciones para mandar a producir (Saldo y Materias Primas)
#2. Se mueven todos los productos necesarios al almacen de Despacho
#3. Se realiza TRX 
#4. Se envía a producir con la info de la TRX


def producirCantidad(sku, cantidad_lotes)
  if(hayCondicionesProducirCantidad(cantidad_lotes))
  	#Si hay Condiciones para Producir, hacemos la TRX.
  	transaccionRealizada = realizarTrx(cantidad_lotes)
  	
  	#Luego de realizar la TRX, movemos todos los productos a la bodega Despacho
  	#Primero vaciamos la bodega de Despacho
  	vaciarAlmacenDespacho
  	#Ahora movemos todas las materias primas a Despacho
	resultadoMoverPrimas = moverPrimasADespacho(cantidad_lotes)

  	if(resultadoMoverPrimas) #Si se pudieron mover, entonces seguimos el flujo
  		respuesta = enviarAProducir(sku, cantidad_lotes.to_i, transaccionRealizada)
  		return respuesta
  	end
  else
  	return false
  end
end

#Retorna True si se pudieron enviar todos los productos necesarios para producir Productos Procesados
def moverPrimasADespacho(cantidad_lotes)
	

end

#Vacia el Almacen de Despacho
def vaciarAlmacenDespacho
	if(Bodega.first!=nil)
	almacenDespacho = Almacen.find_by(despacho: true)
	almacenesAMover = Almacen.where(despacho: false, recepcion: false, pulmon: false)
	almacenesAMover.each do |almacenRecepcion|
		while(almacenDespacho.productos.count >0 && almacenAMover.tieneEspacio(1) do
			productoAEnviar = almacenDespacho.productos.first
			RequestsBodega.new.moverStock(productoAEnviar._id, almacenAMover._id)
			productoAEnviar.almacen= almacenAMover
			almacenDespacho.eliminarEspacio(1)
			almacenAMover.agregarEspacio(1)
		end	
	end

	end
	
end


def enviarAProducir(sku, cantidad_lotes, trx)
	puts 'Enviando a producir'
	puts sku.to_s
	puts 'Lotes' << cantidad_lotes.to_s
	puts trx._id.to_s
	cantidadAProducir = cantidad_lotes*cantidadLoteProducto(sku)
	return RequestsBodega.new.producirStock(sku.to_s, cantidadAProducir.to_i, trx._id.to_s)
end



#Retorna la TRX si se pudo realizar
def realizarTrx(sku, cantidad_lotes)
	puts 'Haciendo Transacción'
	cantidadATransferir =cantidad_lotes*cantidadLoteProducto(sku)* precioProduccionProducto(sku)
	paramsTrx = RequestsBanco.new.transferir(cantidadATransferir.to_i, Cliente.find_by(grupo: 7)._idBanco, cuentaFabrica)
	
	transaccionRealizada = Trx.new(paramsTrx)
	puts transaccionRealizada
	transaccionRealizada.save

	#Restar saldo de la Bodega
	Bodega.restarSaldo(cantidadATransferir)
	return transaccionRealizada	
end

#Nos Da la cuenta de la fábrica
def cuentaFabrica
	return RequestsBodega.new.getCuentaFabrica.to_s
end


def hayCondicionesProducirCantidad(cantidad_lotes)
	if(hayPlataProducirCantidad(cantidad_lotes) && hayMateriasPrimasProducirCantidad(cantidad_lotes))
		return true
	else
		return false
	end
end

#Retorna True si tenemos la cantidad de Primas en Bodega
#Retorna False si no las tenemos
def hayMateriasPrimasProducirCantidad(sku, cantidad_lotes)
	if Bodega.first == nil
		return false
	end
	skusYCantidades = skusMateriasPrimasPorLote(sku)
	skusYCantidades.each do |skuYCantidad|
		skuYCantidad[:cantidad] = skuYCantidad[:cantidad] * cantidad_lotes
		if(skuYCantidad[:cantidad].to_i>Bodega.checkStockTotal(skuYCantidad[:sku]))
			return false
		end
	end

	return true	
end

def hayPlataProducirCantidad(sku, cantidad_lotes)
	if Bodega.first == nil
		return false
	end

	if(cantidad_lotes*cantidadLoteProducto(sku)*precioProduccionProducto(sku)>Bodega.first.saldo)
		return false
	else
		return true
	end
end

def precioProduccionProducto(sku)
	if sku == 10 || sku == '10'
		return 2572
	elsif sku == 23 || sku == '23'
		return 1534
	else
		return 100000000
	end
end

def cantidadLoteProducto(sku)
	if sku == 10 || sku == '10'
		return 900
	elsif sku == 23 || sku == '23'
		return 300
	else
		return 1000000000
	end
end

def skusMateriasPrimasPorLote(sku)
	skus = Array.new
	if sku == 10 || sku == '10'
		skus.append({sku: '23', cantidad: 342})
		skus.append({sku: '26', cantidad: 309})
		skus.append({sku: '4', cantidad: 100})
		skus.append({sku: '27', cantidad: 279})
	elsif sku == 23 || sku == '23'
		skus.append({sku: '8', cantidad: 309})
	else
		skus = nil
	end

	return skus
end

end

