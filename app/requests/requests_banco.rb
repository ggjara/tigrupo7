class RequestsBanco < ApplicationController

def initialize
end

#Busca una cuenta bancaria segun su id y retora el id y el monto
def obtenerCuenta(id)#Checked
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/banco/cuenta/'<<id)).first
	paramsBanco = { _id: jsonResponse['_id'], saldo: jsonResponse['saldo']}
	return paramsBanco
end

#Busca una transaccion segun su id y la retora
def obtenerTransaccion(id)#Checed
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/banco/trx/'<<id)).first
	paramsBanco = { _id: jsonResponse['_id'],
				fechaCreacion: jsonResponse['fechaCreacion'],
        cuentaOrigen: jsonResponse['origen'],
        cuentaDestino: jsonResponse['destino'],
				monto: jsonResponse['monto']}
	return paramsBanco
end

#Busca una lista de transacciones de largo limit (opcional), dado un id de cuenta bancaria entre fechas entregadas
def obtenerCartola(fecha_inicio, fecha_fin, id, limit)#Checked
	transaccions = Array.new
    jsonTransaccions = requestWeb('POST', 'http://mare.ing.puc.cl/banco/cartola/',
      generateParam('fechaInicio',fecha_inicio), generateParam('fechaFin', fecha_fin),
      generateParam('id',id), generateParam('limit',limit))['data']
    jsonTransaccions.each do |jsonTransaccion|
    	transaccion = { _id: jsonTransaccion['_id'],
    				fechaInicio: jsonTransaccion['fechaInicio'],
            fechaFin: jsonTransaccion['fechaFin'],
      }
    	transaccions.append(transaccion)
    end
    return transaccions
end
#Date.new(2009,11,26).to_time.to_i para pasar el time a unix
#DateTime.rfc3339('2015-05-27T07:39:59Z').to_time.to_i para pasar el time a unix

#transfiere monto de origen a destino, retorna la transaccion
def transferir(monto, origen, destino)#Checked
  jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/banco/trx/',
    generateParam('monto',monto), generateParam('origen',origen),
    generateParam('destino', destino))
    paramsTransaccion = { id: jsonResponse['_id'],
    				fechaCreacion: jsonResponse['created_at'],
            cuentaOrigen: jsonResponse['origen'],
            cuentaDestino: jsonResponse['destino'],
    				monto: jsonResponse['monto']}
  	return paramsTransaccion
end

end
