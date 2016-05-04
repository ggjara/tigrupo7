class ProveedorEnviarFactura < ApplicationController

# Orden:
# 0: Se espera que la OC ya fue aceptada. En ese caso, se procede a generar factura
# 1: Se busca la OC y se crea una factura(en db y server) de acuerdo a los datos de la OC
# 2: Se actualiza la información de la OC (db)
# 3: Se envía request a cliente
# 4: Se analiza la respuesta del cliente
# 5.1: Si l cliente acepta la factura. Se actualiza información de la factur en DB y Server.
# 5.2: Si el cliente no acepta la factura. Se actualiza info DByServer. El cliente rechazar anular la OC
# 5.3: Cambio variables de la OC



def initialize
end

#Luego de que le mandamos la respuesta al cliente, creamos la factura y se la enviamos
def enviarFactura(oc_id)
	oc = Oc.find_by(_id: oc_id)
	if(oc==nil)
		puts "xxxOC NO EXISTExxx"
		return false
	else
		facturaCreada=hacerFacturaServerDB(oc)
		puts "---FACTURA CREADA---"
		if(facturaCreada!=false)
		puts "---FACTURA 'ENVIADA'---"
			return true#enviarFacturaACliente(facturaCreada)
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
		puts "xxxNO SE PUDO EMITIR FACTURAxxx"
	end
end

def enviarFacturaACliente(facturaCreada)
	response = requestWeb('GET', uriCliente(facturaCreada.cliente, facturaCreada._id))
	if response!=false
		return intrepretarRespuestaCliente(response, facturaCreada)
	else
			puts "xxxNO SE PUDO AVISAR CLIENTExxx"
		return false
	end
end

def intrepretarRespuestaCliente(response, facturaCreada)
	validado = response['validado']
	if (validado)
		facturaCreada.estadoDB = 'aceptada'
		facturaCreada.save
		return true
	else
		return false
	end

end

def uriCliente(id_cliente, id_factura)
	cliente =Cliente.find_by(_idGrupo: id_cliente)
	if(cliente!=nil)
		uri= 'http://integra'<<cliente.grupo.to_s<<'.ing.puc.cl/facturas/recibir/'<<id_factura
		return uri
	else
		return false
	end
end

end
