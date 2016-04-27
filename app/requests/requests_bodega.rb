class RequestsBodega < ApplicationController
def initialize
end

#Pregunta a Servidor los Almacenes y Retorna un arreglo con todos los Almacenes
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
    return almacenes
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
    return skusAndTotals
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
    return paramsProductos
end



end