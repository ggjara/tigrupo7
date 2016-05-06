class ProveedorRecibirTrx < ApplicationController


# Orden:
# 1: Se valida si corresponde a una TRX para nosotros
# 2: Se verifica si corresponde a una TRX de una OC de nosotros
# 3: Se verifica que es el precio que corresponde
# 4.1: Si cumple, entonces se acepta y se informa.
# 4.2: Si no cumple, se rechaza y se informa. Se eliminan los productos en stockGuardado. Se cambia estado OC

def initialize
end


def recibirTrx(trx_id, factura_id)
	trxDB = guardarTrx(trx_id)
	facturaDB = encontrarFactura(factura_id)
	if(trxDB!=false && facturaDB!=false) #si ambas estan OK
	puts "---TRX Y FACTURA RECIBIDAS---"
		if(validarTrxFactura(trxDB, facturaDB))#Checkeamos que esten relaciondas
		puts "---TRX Y FACTURA VALIDADAS---"
			aceptarTrx(trxDB, facturaDB)
			puts "---TRX ACEPTADA---"
			return true
		else
			rechazarTrx(trxDB, facturaDB)
			return false
		end
	else # trx ya existia en DB || no se encontro factura en DB
		return false
		trxDB.destroy
		facturaDB.destroy
	end
end

def guardarTrx(trx_id)
	#Recibimos la trx, si ya existe una con ese id rechazamos
	if (false)#Trx.find_by(_id: trx_id) != nil)
		puts "xxxTRX YA EXISTExxx-"
		return false
	#si no, la guardamos en la DB
	else
		paramsTrx= RequestsBanco.new.obtenerTransaccion(trx_id)
		trxRecibida = Trx.new(paramsTrx)
		trxRecibida.save
		return trxRecibida
	end
end

def encontrarFactura(factura_id)
	#facturaRecibida = Factura.new(RequestsFactura.new.obtenerFactura(factura_id))#solo para prueba
	facturaRecibida = Factura.find_by(_id: factura_id)#Buscamos la factura en la DB
	if (facturaRecibida == nil)#Si no existe, rechazamos
		puts "xxxFACTURA NO EXISTE EN DBxxx-"
		return false
	else #si existe la entregamos y seguimos
		return facturaRecibida
	end
end


#Valida si es para nosotros, la OC existe, el precio es el que corresponde
def validarTrxFactura(trx, factura)
	#verificamos que la trx sera para nosotros
	if(trx.cuentaDestino != Cliente.find_by(grupo: 7)[:_idBanco])
		puts "xxxDESTINO FACTURA INCORRECTOxxx-"
		return false
	end

	#que el monto de la transaccion corresponda al de la factura
	if(trx.monto != factura.valorTotal)
		puts "MONTOS DISTINTOSxxx-"
		return false
	end
		return true

end


def rechazarTrx(trx,factura)
	#eliminamos la trx de la DB
	trx.destroy
	puts "trx eliminada"
	puts trx._id
	#rechazar Factura (arriba y abajo)
	RequestsFactura.new.anularFactura(factura._id, 'Error en la transaccion, Venta cancelada')
	factura.destroy
	puts "factura eliminada"
	puts factura._id
	#rechazar OC (arriba y abajo)
	RequestsOc.new.rechazarOc(Oc.find_by(_id: factura.id_Oc), 'Error en la transaccion, Venta cancelada')
	Oc.find_by(_id: factura.id_Oc).destroy
	puts "oc eliminada"
	#devolver productos guardados

end


def aceptarTrx(trx,facutra)
	#marcar OC con trx aceptada
	ocAsociada = Oc.find_by(_id: facutra.id_Oc)
	ocAsociada.estadoDB= 'pagada'
	ocAsociada.trxRealizadaDB = true
	ocAsociada.save
	return true
end


end
