class RequestsOc < ApplicationController
def initialize()
end

#Pregunta a Servidor por una OC y retorna los params de esa orden en un hash
def obtenerOc(id)
	jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/oc/obtener/'<<id)).first
	paramsOc = { _id: jsonResponse['_id'],
				cliente: jsonResponse['cliente'],
				proveedor: jsonResponse['proveedor'],
				sku: jsonResponse['sku'],
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
	jsonResponse = requestWebWithoutParams('PUT', 'http://mare.ing.puc.cl/oc/crear',
		generateParam(canal: params[canal]),
		generateParam(cantidad: params[cantidad]),
		generateParam(sku: params[sku]),
		generateParam(proveedor: params[proveedor]),
		generateParam(precio: params[precio]),
		generateParam(notas: params[notas]))
	return jsonResponse
end

#Acepta una OC en servidor y retorna los parámetros de la OC o error
def recepcionarOc(oc_id)
	jsonResponse = requestWebWithoutParams('POST', 'http://mare.ing.puc.cl/oc/recepcionar/'<<oc_id,
		generateParam(id: oc_id))
	paramsOc = { _id: jsonResponse['_id'],
			cliente: jsonResponse['cliente'],
			proveedor: jsonResponse['proveedor'],
			sku: jsonResponse['sku'],
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

#Rechaza una OC en servidor y retorna los parámetros de la OC o error
def rechazarOc(oc_id)
	jsonResponse = requestWebWithoutParams('POST', 'http://mare.ing.puc.cl/oc/rechazar/'<<oc_id,
	generateParam(id: oc_id))
	paramsOc = { _id: jsonResponse['_id'],
			cliente: jsonResponse['cliente'],
			proveedor: jsonResponse['proveedor'],
			sku: jsonResponse['sku'],
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

#Anula una OC en servidor y retorna los parámetros de la OC o error
def anularOc(oc_id)
	jsonResponse = requestWebWithoutParams('DELETE', 'http://mare.ing.puc.cl/oc/anular/'<<oc_id,
	generateParam(id: oc_id))
	paramsOc = { _id: jsonResponse['_id'],
			cliente: jsonResponse['cliente'],
			proveedor: jsonResponse['proveedor'],
			sku: jsonResponse['sku'],
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

end

