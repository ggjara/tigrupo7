class RequestsOc < ApplicationController
def initialize()
end

#Pregunta a Servidor por una OC y retorna los params de esa orden en un hash
def obtenerOc(id)
	jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/oc/obtener/'<<id)).first
	paramsOc = { _id: jsonResponse['_id'],
				cliente: jsonResponse['cliente'],
				proveedor: jsonResponse['proveedor'],
				sku: jsonResponse['39'],
				#fechaDespachos: jsonResponse['fechaDespachos'],
				fechaEntrega: jsonResponse['fechaEntrega'],
				precioUnitario: jsonResponse['precioUnitario'],
				cantidadDespachada: jsonResponse['cantidadDespachada'],
				cantidad: jsonResponse['cantidad'],
				canal: jsonResponse['canal'],
				fechaCreacion: jsonResponse['created_at'],
				estado: jsonResponse['estado']}
	return paramsOc	
end

#Crea una OC en servidor y retorna los parámetros de la OC recién creada o error
def crearOc(params)
end

#Acepta una OC en servidor y retorna los parámetros de la OC o error
def recepcionarOc(id)

end

#Rechaza una OC en servidor y retorna los parámetros de la OC o error
def rechazarOc(id)
	
end

#Anula una OC en servidor y retorna los parámetros de la OC o error
def anularOc(id)
	
end

end

