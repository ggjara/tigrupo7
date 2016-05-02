class ProveedorRecibirTrx < ApplicationController


# Orden:
# 1: Se valida si corresponde a una TRX para nosotros
# 2: Se verifica si corresponde a una TRX de una OC de nosotros
# 3: Se verifica que es el precio que corresponde
# 4.1: Si cumple, entonces se acepta y se informa. 
# 4.2: Si no cumple, se rechaza y se informa. Se eliminan los productos en stockGuardado. Se cambia estado OC

def initialize
end

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

end

#Rechaza Trx en servidor y en DB
#Actualiza OC
def rechazarTrx(trx_id)
	
end

#Acepta TRX en servidor y en DB 
#Actualiza Oc
#Se crea Trx
def aceptarTrx(trx_id)
	
end




end