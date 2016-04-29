class RequestsOc < ApplicationController
def initialize()
end

#Pregunta a Servidor por una OC y retorna los params de esa orden en un hash
def obtenerOc(id) #CHECK
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
#Recibe: canal, cantidad, sku, proveedor, precioUnitario, cliente, fechaEntrega(epoch milisegundos), notas (string sin espacio)
def crearOc(paramsOc) #CHECK
	jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/oc/crear',
		generateParam('canal', paramsOc[:canal]),
		generateParam('cantidad', paramsOc[:cantidad]),
		generateParam('sku', paramsOc[:sku]),
		generateParam('proveedor', paramsOc[:proveedor]),
		generateParam('precioUnitario', paramsOc[:precioUnitario]),
		generateParam('cliente', paramsOc[:cliente]),
		generateParam('fechaEntrega', paramsOc[:fechaEntrega]),
		generateParam('notas', paramsOc[:notas]))
	return jsonResponse
end

#Acepta una OC en servidor y retorna los parámetros de la OC o error
def recepcionarOc(oc_id) #CHECK
	jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/oc/recepcionar/'<<oc_id,
		generateParam('id', oc_id)).first
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
	return jsonResponse	
end

#Rechaza una OC en servidor y retorna los parámetros de la OC o error
def rechazarOc(oc_id, rechazo) #CHECK
	jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/oc/rechazar/'<<oc_id,
	generateParam('id', oc_id), generateParam('rechazo', rechazo)).first
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
	return jsonResponse	
end

#Anula una OC en servidor y retorna los parámetros de la OC o error
def anularOc(oc_id, anulacion) #CHECK
	jsonResponse = requestWeb('DELETE', 'http://mare.ing.puc.cl/oc/anular/'<<oc_id,
	generateParam('id', oc_id), generateParam('anulacion', anulacion)).first
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

