class ProducirProductosProcesados < ApplicationController

def initialize(sku)
  @sku =sku 
end

#1. Se verifica que estén las condiciones para mandar a producir (Saldo y Materias Primas)
#2. Se mueven todos los productos necesarios al almacen de Despacho
#3. Se realiza TRX 
#4. Se envía a producir con la info de la TRX


def producirCantidad(cantidad_lotes)
  if(hayCondicionesProducirCantidad(cantidad_lotes))
  	#Si hay Condiciones para Producir, hacemos la TRX.
  	transaccionRealizada = realizarTrx(cantidad_lotes)
  	#Luego de realizar la TRX, movemos todos los productos a la bodega Despacho
  	
  	#Luego de mover los productos a Depsacho, Enviamos a producir.
  	respuesta = enviarAProducir(@sku, cantidad_lotes.to_i, transaccionRealizada)
  	return respuesta
  else
  	return false
  end
end


def enviarAProducir(sku, cantidad_lotes, trx)
	puts 'Enviando a producir'
	puts sku.to_s
	puts 'Lotes' << cantidad_lotes.to_s
	puts trx._id.to_s
	cantidadAProducir = cantidad_lotes*cantidadLoteProducto(@sku)
	return RequestsBodega.new.producirStock(sku.to_s, cantidadAProducir.to_i, trx._id.to_s)
end



def realizarTrx(cantidad_lotes)
	puts 'Haciendo Transacción'
	cantidadATransferir =cantidad_lotes*cantidadLoteProducto(@sku)* precioProduccionProducto(@sku)
	paramsTrx = RequestsBanco.new.transferir(cantidadATransferir.to_i, Cliente.find_by(grupo: 7)._idBanco, cuentaFabrica)
	
	transaccionRealizada = Trx.new(paramsTrx)
	puts transaccionRealizada
	transaccionRealizada.save
	#Restar saldo de la Bodega
	Bodega.restarSaldo(cantidadATransferir)

	return transaccionRealizada	
end

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

#Por Hacer
def hayMateriasPrimasProducirCantidad(cantidad_lotes)
	if Bodega.first == nil
		return false
	end
	skusYCantidades = skusMateriasPrimasPorLote(@sku)
	skusYCantidades.each do |skuYCantidad|
		skuYCantidad[:cantidad] = skuYCantidad[:cantidad] * cantidad_lotes
		puts skuYCantidad[:cantidad]
		if(skuYCantidad[:cantidad].to_i>Bodega.checkStockTotal(skuYCantidad[:sku]))
			return false
		end
	end

	return true
	
end

def hayPlataProducirCantidad(cantidad_lotes)
	if Bodega.first == nil
		return false
	end

	if(cantidad_lotes*cantidadLoteProducto(@sku)*precioProduccionProducto(@sku)>Bodega.first.saldo)
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
		return 100000
	end
end

def cantidadLoteProducto(sku)
	if sku == 10 || sku == '10'
		return 900
	elsif sku == 23 || sku == '23'
		return 300
	else
		return 1000000
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

