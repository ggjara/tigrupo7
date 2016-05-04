class ProveedorRecibirTrx < ApplicationController


# Orden:
# 1: Se valida si corresponde a una TRX para nosotros
# 2: Se verifica si corresponde a una TRX de una OC de nosotros
# 3: Se verifica que es el precio que corresponde
# 4.1: Si cumple, entonces se acepta y se informa.
# 4.2: Si no cumple, se rechaza y se informa. Se eliminan los productos en stockGuardado. Se cambia estado OC

def initialize
end

#falta implentar el uso de la facutra como parametro, por ahora solo use: factura
def recibirTrx(trx_id)
	if(validarTrxRecibida(trx_id))
		aceptarTrx(trx_id)
		return true
	else
		rechazarTrx(trx_id)
		return false
	end
end


#Valida si es para nosotros, la OC existe, el precio es el que corresponde
def validarTrxRecibida(trx_id)
	#Recibimos la trx, si ya existe una con ese id rechazamos
	trxRecibida
	if (Trx.find_by(_id: trx_id) != nil)
		return false
	#si no, la guardamos en la DB
	else
		paramsTrx= RequestsBanco.new.obtenerTransaccion(trx_id)
		trxRecibida = Trx.new(paramsTrx)
		trxRecibida.save
	end

	#verificamos que sera para nosotros
	if(trxRecibida.cuentaDestino != '571262c3a980ba030058ab60')
		return false
	end
	#que el monto de la transaccion corresponda al de la facturas
	if(trxRecibida.monto != factura.valorTotal)
		return false
	end
	#todo ok: true
	else
		return true
	end
end




def rechazarTrx(trx_id)
	#eliminamos la trx de la DB
	Trx.find_by(_id: trx_id).destroy
	#rechazar Factura (arriba y abajo)
	RequestsFactura.anularFactura(factura.id, 'Error en la transaccion, Venta cancelada')
	Factura.find_by(_id: factura.id).destroy
	#rechazar OC (arriba y abajo)
	RequestsOc.rechazarOc(Oc.find_by(_id: factura.id_Oc), 'Error en la transaccion, Venta cancelada')
	Oc.find_by(_id: factura.id_Oc).destroy
	#devolver productos guardados

end


def aceptarTrx(trx_id)
	#marcar OC con trx aceptada
	Oc.find_by(_id: factura.id_Oc).estadoDB= 'pagada'
	#gatillar despacho

end




end
