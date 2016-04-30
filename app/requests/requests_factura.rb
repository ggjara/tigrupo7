class RequestsFactura < ApplicationController
def initialize
end

#Busca en el servidor una factura por su id, retorna la factura
def obtenerFactura(id)#checked
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/facturas/'<<id)).first
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

def pagarFactura(id)#Checked
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/pay/',
    generateParam('id',id)).first
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

def rechazarFactura(id, motivo)#Checked
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/reject/',
    generateParam('id',id), generateParam('motivo',motivo)).first
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

def anularFactura(id, motivo)
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/cancel/',
    generateParam('id',id), generateParam('motivo',motivo)).first
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

def crearBoleta(proveedor, cliente, monto)#Checked
  jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/facturas/boleta/',
    generateParam('proveedor',proveedor), generateParam('cliente',cliente),
    generateParam('total',monto))
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
