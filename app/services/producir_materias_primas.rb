class ProducirMateriasPrimas < ApplicationController
def initialize(sku)
  @sku =sku 
end

#1. Se verifica que haya plata para mandar a producir
#2. Se realiza TRX en caso de que haya plata
#3. Se envía a producir con la info de la TRX


def producirCantidad(cantidad)
  if(hayPlataProducirCantidad(cantidad))
  	#Si hay Plata, Realizamos la TRX
  	transaccionRealizada = realizarTrx(cantidad)
  	#Luego de realizar la TRX, envíamos a producir
  	respuesta = enviarAProducir(@sku, cantidad.to_i, transaccionRealizada)
  	puts 'Produccion'
  	return respuesta
  else
  	return false
  end
end


def enviarAProducir(sku, cantidad, trx)
	puts 'Enviando a producir'
	puts sku.to_s
	puts cantidad.to_i
	puts trx._id.to_s
	return RequestsBodega.new.producirStock(sku.to_s, cantidad.to_i, trx._id.to_s)
end



def realizarTrx(cantidad)
	puts 'Haciendo Transacción'
	cantidadATransferir =cantidad*precioProduccionProducto(@sku)
	paramsTrx = RequestsBanco.new.transferir(cantidadATransferir, Cliente.find_by(grupo: 7)._idBanco, cuentaFabrica)
	
	transaccionRealizada = Trx.new(paramsTrx)
	puts 'Transaccion'
	puts transaccionRealizada
	transaccionRealizada.save
	#Restar saldo de la Bodega

	Bodega.restarSaldo(cantidadATransferir)
	return transaccionRealizada	
end

def cuentaFabrica
	return RequestsBodega.new.getCuentaFabrica.to_s
end

def hayPlataProducirCantidad(cantidad)
	puts 'Verificando que Hay Plata'
	if Bodega.first == nil
		return false
	end

	if(cantidad*precioProduccionProducto(@sku)>Bodega.first.saldo)
		return false
	else
		puts 'Hay Plata'
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

