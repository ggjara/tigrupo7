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
  	respuesta = enviarAProducir(cantidad, transaccionRealizada, cantidad.to_i)
  	return true
  else
  	return false
  end
end


def enviarAProducir(cantidad, trx, cantidad)
	return RequestsBodega.new.producirStock(@sku.to_s, trx._id, cantidad.to_i)
end



def realizarTrx(cantidad)
	cantidadATransferir =cantidad*precioProduccionProducto(@sku)
	paramsTrx = RequestsBanco.new.transferir(cantidadATransferir, Cliente.find_by(grupo: 7)._idBanco, cuentaFabrica)
	
	transaccionRealizada = Trx.new(paramsTrx)
	transaccionRealizada.save
	#Restar saldo de la Bodega
	Bodega.restarSaldo(cantidadATransferir)
	return transaccionRealizada	
end

def cuentaFabrica
	return RequestsBodega.new.getCuentaFabrica.to_s
end

def hayPlataProducirCantidad(cantidad)
	if Bodega.first == nil
		return false
	end

	if(cantidad*precioProduccionProducto(@sku)>Bodega.first.saldo)
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

