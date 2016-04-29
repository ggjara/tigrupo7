class RequestsFactura < ApplicationController
def initialize
end

#Falta chequear nombre parametros
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


def emitirFactura(id)
  jasonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/facturas/',
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
  jasonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/pay',
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
  jasonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/reject',
    generateParam('id',id), generateParam('motivoRechazo',motivo)).first
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
  jasonResponse = requestWeb('POST', 'http://mare.ing.puc.cl/facturas/cancel',
    generateParam('id',id), generateParam('motivoAnulacion',motivo)).first
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

def crearBoleta(id_proveedor, cliente, monto)
  jasonResponse = requestWeb('PUT', 'http://mare.ing.puc.cl/facturas/boleta',
    generateParam('id',id_proveedor), generateParam('cliente',client),
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
