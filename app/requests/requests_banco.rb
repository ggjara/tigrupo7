class RequestsBanco < ApplicationController

def initialize
end

def obtenerCuenta(id)
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/banco/cuenta/'<<id)).first
	paramsBanco = { _id: jsonResponse['_id'], saldo: jsonResponse['saldo']}
	return paramsBanco
end

def obtenerTransaccion(id)
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/trx/'<<id)).first
	paramsBanco = { _id: jsonResponse['_id'],
				fechaCreacion: jsonResponse['fechaCreacion'],
        cuentaOrigen: jsonResponse['cuentaOrigen'],
        cuentaDestino: jsonResponse['cuentaDestino'],
				monto: jsonResponse['monto']}
	return paramsBanco
end

def obtenerCartola(fecha_inicio, fecha_fin, id, limit)
	transaccions = Array.new
    jsonTransaccions = requestWeb('POST', 'http://mare.ing.puc.cl/cartola/',
      generateParam('fechaInicio',fecha_inicio), generateParam('fechaFin', fecha_fin),
      generateParam('id',id), generateParam('limit'),limit).first
    jsonTransaccions.each do |jsonTransaccion|
    	transaccion = { id: jsonResponse['id'],
    				fechaInicio: jsonResponse['fechaInicio'],
            fechaFin: jsonResponse['fechaFin'],
      }
    	transaccions.append(transaccion)
    end
    return transaccions
end

def transferir(monto, origen, destino)
  jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/trx/',
    generateParam('monto',monto), generateParam("cuentaOrigen",origen),
    generateParam('cuentaDestino', destino)).first
    paramsTransaccion = { _id: jsonResponse['_id'],
    				fechaCreacion: jsonResponse['fechaCreacion'],
            cuentaOrigen: jsonResponse['cuentaOrigen'],
            cuentaDestino: jsonResponse['cuentaDestino'],
    				monto: jsonResponse['monto']}
  	return paramsTransaccion
end

end
