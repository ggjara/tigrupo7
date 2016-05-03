class RequestsOc < ApplicationController
def initialize
end

#Pregunta a Servidor por una OC y retorna los params de esa orden en un hash
def obtenerOc(id) #CHECK
	jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/oc/obtener/'<<id))
	if(jsonResponse==false)
		return jsonResponse
	else
		jsonResponse = jsonResponse.first
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
				estado: jsonResponse['estado']
		}
		return paramsOc
	end
end

#Crea una OC en servidor y retorna los parámetros de la OC recién creada o error
#Recibe: canal, cantidad, sku, proveedor, precioUnitario, cliente, fechaEntrega(epoch milisegundos), notas (string sin espacio)
def crearOc(paramsOc) #FALTA ENTREGAR ID
	jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/oc/crear',
		generateParam('canal', paramsOc[:canal]),
		generateParam('cantidad', paramsOc[:cantidad]),
		generateParam('sku', paramsOc[:sku]),
		generateParam('proveedor', paramsOc[:proveedor]),
		generateParam('precioUnitario', paramsOc[:precioUnitario]),
		generateParam('cliente', paramsOc[:cliente]),
		generateParam('fechaEntrega', paramsOc[:fechaEntrega]),
		generateParam('notas', paramsOc[:notas]))
	if(jsonResponse==false)
		return jsonResponse
	else
		
		paramsResponse = { _id: jsonResponse['_id'],
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
				estado: jsonResponse['estado']
		}
		return paramsResponse
	end
end

#Acepta una OC en servidor y retorna los parámetros de la OC o error
def recepcionarOc(oc_id) #CHECK
	jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/oc/recepcionar/'<<oc_id,
		generateParam('id', oc_id))
	if(jsonResponse==false)
		return jsonResponse
	else
		jsonResponse = jsonResponse.first
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

#Rechaza una OC en servidor y retorna los parámetros de la OC o error
def rechazarOc(oc_id, rechazo) #CHECK
	jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/oc/rechazar/'<<oc_id,
	generateParam('id', oc_id), generateParam('rechazo', rechazo)).first
	if(jsonResponse==false)
		return jsonResponse
	else
		jsonResponse = jsonResponse.first
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

#Anula una OC en servidor y retorna los parámetros de la OC o error
def anularOc(oc_id, anulacion) #CHECK
	jsonResponse = requestWeb('DELETE', 'http://mare.ing.puc.cl/oc/anular/'<<oc_id,
	generateParam('id', oc_id), generateParam('anulacion', anulacion)).first
	if(jsonResponse==false)
		return jsonResponse
	else
		jsonResponse = jsonResponse.first
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

end
