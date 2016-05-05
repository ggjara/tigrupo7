	class ProducirMateriasPrimas < ApplicationController
def initialize(sku)
  @sku =sku 
end

#1. Se verifica que haya plata para mandar a producir
#2. Se realiza TRX en caso de que haya plata
#3. Se envía a producir con la info de la TRX


def producirCantidad(cantidad_lotes)
  if(hayPlataProducirCantidad(cantidad_lotes))
  	#Si hay Plata, Realizamos la TRX
  	transaccionRealizada = realizarTrx(cantidad_lotes)
  	#Luego de realizar la TRX, envíamos a producir
  	respuesta = enviarAProducir(@sku, cantidad_lotes.to_i, transaccionRealizada)
  	return respuesta
  else
  	return false
  end
end


def enviarAProducir(sku, cantidad_lotes, trx)
	puts '---Enviando a producir--'
	puts 'Sku: '<<sku.to_s
	puts 'Lotes: ' << cantidad_lotes.to_s
	puts 'TRX: '<<trx._id.to_s
	cantidadAproducir =cantidad_lotes * cantidadLoteProducto(@sku)
	return RequestsBodega.new.producirStock(sku.to_s, cantidadAproducir.to_i, trx._id.to_s)
end



def realizarTrx(cantidad_lotes)
	puts 'Haciendo Transacción'
	cantidadATransferir =cantidad_lotes*cantidadLoteProducto(@sku)*precioProduccionProducto(@sku)
	paramsTrx = RequestsBanco.new.transferir(cantidadATransferir.to_i, Cliente.find_by(grupo: 7)._idBanco, cuentaFabrica)
	
	transaccionRealizada = Trx.new(paramsTrx)
	puts "Trx: " << transaccionRealizada._id
	transaccionRealizada.save
	#Restar saldo de la Bodega
	Bodega.restarSaldo(cantidadATransferir)
	return transaccionRealizada	
end

def cuentaFabrica
	return RequestsBodega.new.getCuentaFabrica.to_s
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
	if sku == 1 || sku == '1'
		return 892
	elsif sku == 39 || sku == '39'
		return 889

	else
		return 100000
	end
end

def cantidadLoteProducto(sku)
	if sku == 1 || sku == '1'
		return 300
	elsif sku == 39 || sku == '39'
		return 250

	else
		return 1000000
	end
end

end

