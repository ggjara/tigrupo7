class RequestsFactura < ApplicationController
def initialize
end

#Busca en el servidor una factura por su id, retorna la factura
def obtenerFactura(id)
  jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/facturas/'<<id)).first
	paramsFactura = { _id: jsonResponse['_id'],
		fechaCreacion: jsonResponse['created_at'],
		proveedor: jsonResponse['proveedor'],
		cliente: jsonResponse['cliente'],
		valorBruto: jsonResponse['valorBruto'],
		iva: jsonResponse['iva'],
		valorTotal: jsonResponse['valorTotal'],
		estadoPago: jsonResponse['estadoPago'],
		fechaPago: jsonResponse['fechaPago'],
		id_Oc: jsonResponse['id_oc'],
		motivoRechazo: jsonResponse['motivoRechazo'],
		motivoAnulacion: jsonResponse['motivoAnulacion']}
	return paramsFactura
end

#crea una factura basado en la id de una oc, retorna la factura
def emitirFactura(id)#Checked
  jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/facturas/',
    generateParam('id',id)).first
  paramsFactura = { _id: jsonResponse['_id'],
		fechaCreacion: jsonResponse['created_at'],
		proveedor: jsonResponse['proveedor'],
		cliente: jsonResponse['cliente'],
		valorBruto: jsonResponse['valorBruto'],
		iva: jsonResponse['iva'],
		valorTotal: jsonResponse['valorTotal'],
		estadoPago: jsonResponse['estadoPago'],
		fechaPago: jsonResponse['fechaPago'],
		id_Oc: jsonResponse['id_oc'],
		motivoRechazo: jsonResponse['motivoRechazo'],
		motivoAnulacion: jsonResponse['motivoAnulacion']}
    return paramsFactura
end

def pagarFactura(id)
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/pay',
    generateParam('id',id)).first
  paramsFactura = { _id: jsonResponse['_id'],
  			fechaCreacion: jsonResponse['created_at'],
  			proveedor: jsonResponse['proveedor'],
  			cliente: jsonResponse['cliente'],
  			valorBruto: jsonResponse['valorBruto'],
  			iva: jsonResponse['iva'],
  			valorTotal: jsonResponse['valorTotal'],
  			estadoPago: jsonResponse['estadoPago'],
  			fechaPago: jsonResponse['fechaPago'],
  			id_Oc: jsonResponse['id_oc'],
  			motivoRechazo: jsonResponse['motivoRechazo'],
  			motivoAnulacion: jsonResponse['motivoAnulacion']}
  return paramsFactura
end

def rechazarFactura(id, motivo)
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/reject',
    generateParam('id',id), generateParam('motivo',motivo)).first
  paramsFactura = { _id: jsonResponse['_id'],
  			fechaCreacion: jsonResponse['created_at'],
  			proveedor: jsonResponse['proveedor'],
  			cliente: jsonResponse['cliente'],
  			valorBruto: jsonResponse['valorBruto'],
  			iva: jsonResponse['iva'],
  			valorTotal: jsonResponse['valorTotal'],
  			estadoPago: jsonResponse['estadoPago'],
  			fechaPago: jsonResponse['fechaPago'],
  			id_Oc: jsonResponse['id_oc'],
  			motivoRechazo: jsonResponse['motivoRechazo'],
  			motivoAnulacion: jsonResponse['motivoAnulacion']}
  return paramsFactura
end

def anularFactura(id, motivo)
  jsonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/cancel',
    generateParam('id',id), generateParam('motivo',motivo)).first
  paramsFactura = { _id: jsonResponse['_id'],
  			fechaCreacion: jsonResponse['created_at'],
  			proveedor: jsonResponse['proveedor'],
  			cliente: jsonResponse['cliente'],
  			valorBruto: jsonResponse['valorBruto'],
  			iva: jsonResponse['iva'],
  			valorTotal: jsonResponse['valorTotal'],
  			estadoPago: jsonResponse['estadoPago'],
  			fechaPago: jsonResponse['fechaPago'],
  			id_Oc: jsonResponse['id_oc'],
  			motivoRechazo: jsonResponse['motivoRechazo'],
  			motivoAnulacion: jsonResponse['motivoAnulacion']}
  return paramsFactura
end

def crearBoleta(proveedor, cliente, monto)
  jsonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/facturas/boleta',
    generateParam('proveedor',proveedor), generateParam('cliente',cliente),
    generateParam('total',monto)).first
  paramsBoleta = { _id: jsonResponse['_id'],
				fechaCreacion: jsonResponse['created_at'],
				proveedor: jsonResponse['proveedor'],
				cliente: jsonResponse['cliente'],
				valorBruto: jsonResponse['valorBruto'],
				iva: jsonResponse['iva'],
				valorTotal: jsonResponse['valorTotal'],
				estadoPago: jsonResponse['estadoPago'],
				fechaPago: jsonResponse['fechaPago'],
				id_Oc: jsonResponse['id_oc'],
				motivoRechazo: jsonResponse['motivoRechazo'],
				motivoAnulacion: jsonResponse['motivoAnulacion']}
	return paramsBoleta
end
end
