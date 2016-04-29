class RequestsBodega < ApplicationController
def initialize
end

#Pregunta a Servidor los Almacenes y Retorna un arreglo con todos los params de cada Almacen
def getAlmacenes
	bodegaGrupo7 = Bodega.find_by(name: 'grupo7')
	almacenes = Array.new
    jsonAlmacenes = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/almacenes')
    jsonAlmacenes.each do |jsonAlmacen|
    	almacen = {
    		bodega_id: bodegaGrupo7.id,
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
    return almacenes #CHECK
end

#Recibe un :_id de un almacen y retorna que sku (y su total) tienen disponible en almacen
def getSkusWithStock(almacen_id)
	skusAndTotals = Array.new
	jsonSkusWithStock = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock', 
      generateParam('almacenId',almacen_id))
    jsonSkusWithStock.each do |jsonSku|
      skuAndTotal = {sku: jsonSku['_id'], total: jsonSku['total']}
      skusAndTotals.append(skuAndTotal)
    end
    return skusAndTotals #CHECK
end

#Recibe un :_id de un almacen y un :sku de un producto y retorna todos los productos con ese sku en ese almacen.
def getStock(almacen_id, sku)
	paramsProductos=Array.new
	jsonProducts = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/stock', 
      generateParam('almacenId', almacen_id), generateParam('sku', sku))
    jsonProducts.each do |jsonProduct|
      paramsProducto = {
        almacen_id: Almacen.find_by(_id: almacen_id).id, 
        _id: jsonProduct['_id'], 
        sku: jsonProduct['sku'], 
        costo: jsonProduct['costo'], 
        despachado: jsonProduct['despachado'], 
        precio: jsonProduct['precio'], 
        grupo: jsonProduct['grupo']}
        paramsProductos.append(paramsProducto)
    end
    return paramsProductos #CHECK
end

# Recibe un producto_id y un almacen_id y mueve ese producto al almacen (solo si hay espacio)
def moverStock(producto_id, almacen_id)
  jsonMoverStock = requestWeb('POST', 'http://integracion-2016-dev.herokuapp.com/bodega/moveStock', 
    generateParam('productoId', producto_id), generateParam('almacenId', almacen_id))
  return jsonMoverStock
end

# Recibe un productoId y un almacen_id (recepcion) y mueve el producto a otra bodega
def moverStockBodega(producto_id, almacen_id)  
end 

# Despacha un producto a un grupo
def despacharStock(producto_id, direccion, precio, oc_id)
end

# Se necesita haber pagado y tener las materias primas en despacho
# Manda a producir un producto, de acuerdo a una trx pagada anteriormente y con la cantidad pagada
def producirStock(sku, trx_id, cantidad)
end

# Entrega la cuenta de la fábrica 
def getCuentaFabrica #CHECK
    jsonCuentaFabrica = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/fabrica/getCuenta')
    return jsonCuentaFabrica
end



end