class RequestsBodega < ApplicationController
def initialize
end

#Pregunta a Servidor los Almacenes y Retorna un arreglo con todos los params de cada Almacen
def getAlmacenes
	almacenes = Array.new
  jsonAlmacenes = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/almacenes')
	if(jsonAlmacenes==false)
		return jsonAlmacenes
	else
		jsonAlmacenes.each do |jsonAlmacen|
    	almacen = {
    		_id: jsonAlmacen['_id'],
         	grupo: jsonAlmacen['grupo'],
         	pulmon: jsonAlmacen['pulmon'],
         	despacho: jsonAlmacen['despacho'],
         	recepcion: jsonAlmacen['recepcion'],
         	totalSpace: jsonAlmacen['totalSpace'],
         	usedSpace: jsonAlmacen['usedSpace']
    	}
    	almacenes.append(almacen)
    end
    return almacenes #CHECK & V
	end
end

#Recibe un :_id de un almacen y retorna que sku (y su total) tienen disponible en almacen
def getSkusWithStock(almacen_id)
	skusAndTotals = Array.new
	jsonSkusWithStock = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock',
      generateParam('almacenId',almacen_id))
	if(jsonSkusWithStock==false)
		return jsonSkusWithStock
	else
		jsonSkusWithStock.each do |jsonSku|
	    skuAndTotal = {sku: jsonSku['_id'], total: jsonSku['total']}
	    skusAndTotals.append(skuAndTotal)
    end
		return skusAndTotals #CHECK & V
	end
end

#Recibe un :_id de un almacen y un :sku de un producto y retorna todos los productos con ese sku en ese almacen.
def getStock(almacen_id, sku, limit)
	paramsProductos=Array.new
	jsonProducts = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/stock',
      generateParam('almacenId', almacen_id), generateParam('sku', sku), generateParam('limit', limit.to_i))
	if(jsonProducts==false)
		return jsonProducts
	else
		jsonProducts.each do |jsonProduct|
      paramsProducto = {
        _id: jsonProduct['_id'],
        sku: jsonProduct['sku'],
        costo: jsonProduct['costo'],
        despachado: jsonProduct['despachado'],
        precio: jsonProduct['precio'],
        grupo: jsonProduct['grupo']}
        paramsProductos.append(paramsProducto)
    end
    return paramsProductos #CHECK & V
	end
end

# Recibe un producto_id y un almacen_id y mueve ese producto al almacen (solo si hay espacio)
def moverStock(producto_id, almacen_id) #CHECK & V
  jsonMoverStock = requestWeb('POST', 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock',
    generateParam('productoId', producto_id.to_s), generateParam('almacenId', almacen_id.to_s))
	if(jsonMoverStock==false)
		return jsonMoverStock
	else
    if(jsonMoverStock['almacen']!=nil)
      productoParams = {
      _id: jsonMoverStock['_id'],
      grupo: jsonMoverStock['grupo'],
      almacen_id: jsonMoverStock['almacen']['_id'],
      sku: jsonMoverStock['sku'],
      direccion: jsonMoverStock['direccion'],
      precio: jsonMoverStock['precio'],
      despachado: jsonMoverStock['despachado'],
      costo: jsonMoverStock['costo']
      }
    else
      productoParams=nil
    end
  	return productoParams
	end
end

# Recibe un productoId y un almacen_id (recepcion) y mueve el producto a otra bodega
def moverStockBodega(producto_id, almacen_id, oc_id, precio) #CHECK
  jsonMoverStockBodega = requestWeb('POST', 'http://integracion-2016-dev.herokuapp.com/bodega/moveStockBodega',
    generateParam('productoId', producto_id), generateParam('almacenId', almacen_id),
    generateParam('oc', oc_id), generateParam('precio', precio))
	if(jsonMoverStockBodega==false)
		return jsonMoverStockBodega
	else
		if(jsonMoverStockBodega['almacen']!=nil)
		  productoParams = {
		  _id: jsonMoverStockBodega['_id'],
		  grupo: jsonMoverStockBodega['grupo'],
		  sku: jsonMoverStockBodega['sku'],
		  direccion: jsonMoverStockBodega['direccion'],
		  precio: jsonMoverStockBodega['precio'],
		  despachado: jsonMoverStockBodega['despachado'],
		  costo: jsonMoverStockBodega['costo']
		  }
    else
      productoParams=nil
    end
  	return productoParams
	end
end

# Despacha un producto a una dirección de una OC #CHECK
def despacharStock(producto_id, direccion, precio, oc_id)
  puts 'A mandar: '
  puts producto_id
  puts direccion
  puts precio
  puts oc_id
  jsonDespacharStock = requestWeb('DELETE', 'http://integracion-2016-dev.herokuapp.com/bodega/stock',
    generateParam('productoId', producto_id.to_s), generateParam('direccion', direccion.to_s),
    generateParam('precio', precio.to_i), generateParam('oc', oc_id.to_s))

	return jsonDespacharStock
end

# Se necesita haber pagado y tener las materias primas en despacho
# Manda a producir un producto, de acuerdo a una trx pagada anteriormente y con la cantidad pagada
def producirStock(sku, cantidad, trx_id) #CHECK
  jsonProducirStock = requestWeb('PUT', 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/fabricar',
    generateParam('sku', sku), generateParam('cantidad', cantidad),
    generateParam('trxId', trx_id))
    return jsonProducirStock
end

# Entrega la cuenta de la fábrica (string)
def getCuentaFabrica #CHECK
    jsonCuentaFabrica = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta')
    return jsonCuentaFabrica['cuentaId']
end

end
