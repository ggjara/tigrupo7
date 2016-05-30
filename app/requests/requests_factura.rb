class RequestsFactura < ApplicationController
def initialize
end

#Busca en el servidor una factura por su id, retorna la factura
def obtenerFactura(id)#Validates
  jsonResponse = requestWebWithoutParams('GET', (ENV["url_factura"]+id))

  if(jsonResponse==false)
    return jsonResponse
  else
    jsonResponse = jsonResponse.first
    paramsFactura = { _id: jsonResponse['_id'],
      created_at: jsonResponse['created_at'],#fechaCreacion
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'],
      iva: jsonResponse['iva'],
      valorTotal: jsonResponse['total'],
      estadoPago: jsonResponse['estado'],
      updated_at: jsonResponse['updated_at'],#fechaUpdate
      id_Oc: jsonResponse['oc'],
      motivoRechazo: jsonResponse['rechazo'],
      motivoAnulacion: jsonResponse['anulacion']
    }
    return paramsFactura
  end
end

def emitirFactura(id)#Validates
  jsonResponse = requestWeb('PUT', ENV["url_factura"],
    generateParam('oc',id))

  if(jsonResponse==false)
    return jsonResponse
  else
    paramsFactura = { _id: jsonResponse['_id'],
      created_at: jsonResponse['created_at'],
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'],
      iva: jsonResponse['iva'],
      valorTotal: jsonResponse['total'],
      estadoPago: jsonResponse['estado'],
      updated_at: jsonResponse['updated_at'],
      id_Oc: jsonResponse['oc']['_id'],
      motivoRechazo: jsonResponse['rechazo'],
      motivoAnulacion: jsonResponse['anulacion']
    }
    return paramsFactura
  end
end

def pagarFactura(id)#Validates
  jsonResponse = requestWeb('POST', ENV["url_factura"]+"pay/",
    generateParam('id',id))

  if(jsonResponse==false)
    return jsonResponse
  else
    jsonResponse = jsonResponse.first
    paramsFactura = { _id: jsonResponse['_id'],
      fechaCreacion: jsonResponse['created_at'],
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'],
      iva: jsonResponse['iva'],
      valorTotal: jsonResponse['total'],
      estadoPago: jsonResponse['estado'],
      fechaUpdate: jsonResponse['updated_at'],
      id_Oc: jsonResponse['oc'],
      motivoRechazo: jsonResponse['rechazo'],
      motivoAnulacion: jsonResponse['anulacion']
    }
    return paramsFactura
  end
end

def rechazarFactura(id, motivo)#Validates
  jsonResponse = requestWeb('POST', ENV["url_factura"]+"reject/",
    generateParam('id',id), generateParam('motivo',motivo))
  if(jsonResponse==false)
    return jsonResponse
  else
    jsonResponse = jsonResponse.first
    paramsFactura = { _id: jsonResponse['_id'],
      fechaCreacion: jsonResponse['created_at'],
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'],
      iva: jsonResponse['iva'],
      valorTotal: jsonResponse['total'],
      estadoPago: jsonResponse['estado'],
      fechaUpdate: jsonResponse['updated_at'],
      id_Oc: jsonResponse['oc'],
      motivoRechazo: jsonResponse['rechazo'],
      motivoAnulacion: jsonResponse['anulacion']
    }
    return paramsFactura
  end
end

def anularFactura(id, motivo)#Validates
  jsonResponse = requestWeb('POST', ENV["url_factura"]+"cancel/",
    generateParam('id',id), generateParam('motivo',motivo))
  if(jsonResponse==false)
    return jsonResponse
  else
    jsonResponse = jsonResponse.first
    paramsFactura = { _id: jsonResponse['_id'],
      fechaCreacion: jsonResponse['created_at'],
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'],
      iva: jsonResponse['iva'],
      valorTotal: jsonResponse['total'],
      estadoPago: jsonResponse['estado'],
      fechaUpdate: jsonResponse['updated_at'],
      id_Oc: jsonResponse['oc'],
      motivoRechazo: jsonResponse['rechazo'],
      motivoAnulacion: jsonResponse['anulacion']
    }
    return paramsFactura
  end
end

def crearBoleta(proveedor, cliente, monto)#Validates
  jsonResponse = requestWeb('PUT', ENV["url_factura"]+"boleta/",
    generateParam('proveedor',proveedor), generateParam('cliente',cliente),
    generateParam('total',monto))
  if(jsonResponse==false)
    return jsonResponse
  else
    paramsFactura = { _id: jsonResponse['_id'],
      fechaCreacion: jsonResponse['created_at'],
      proveedor: jsonResponse['proveedor'],
      cliente: jsonResponse['cliente'],
      valorBruto: jsonResponse['bruto'].to_i,
      iva: jsonResponse['iva'].to_i,
      valorTotal: jsonResponse['total'].to_i,
      estadoPago: jsonResponse['estado'],
      fechaUpdate: jsonResponse['updated_at'],
      id_Oc: jsonResponse['oc']
    }
    return paramsFactura
  end
end
end
