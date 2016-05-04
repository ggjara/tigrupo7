class ProveedorEnviarFacturaFtp < ApplicationController

# Orden:
# 0: Se espera que la OC ya fue aceptada. En ese caso, se procede a generar factura
# 1: Se busca la OC y se crea una factura(en db y server) de acuerdo a los datos de la OC
# 2: Se actualiza la información de la OC (db)




def initialize
end

#Luego de que le mandamos la respuesta al cliente, creamos la factura y se la enviamos
def enviarFactura(oc_id)
	oc = Oc.find_by(_id: oc_id)
	if(oc==nil)
		return false
	else
		facturaCreada=hacerFacturaServerDB(oc)
		if(facturaCreada!=false)
			return true
		else
			return false
		end
	end

end

def hacerFacturaServerDB(oc)
	paramsFactura = RequestsFactura.new.emitirFactura(oc._id)
	if(paramsFactura!=nil)
		facturaCreada= Factura.new(paramsFactura)
		facturaCreada.save
		oc.facturaRealizadaDB=true
		oc.save
		return facturaCreada
	else
		return false
	end
end



end