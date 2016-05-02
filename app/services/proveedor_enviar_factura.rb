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
def enviarFacturaPorOc(oc_id)


def hacerFacturaServerDB(oc_id)
	
end


end