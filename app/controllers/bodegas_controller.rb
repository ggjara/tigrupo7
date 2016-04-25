class BodegasController < ApplicationController
#requestWeb(typeOfRequest, uri, *paramsRequest)
#generateParam(name, value)

def consultarInfo
	render json: {NBodegas: @bodegas}
end


def crearInfo
	Bodega.destroy_all
	Almacen.destroy_all
	Producto.destroy_all
	bodegaGrupo7 = Bodega.new(name: 'grupo7')
	bodegaGrupo7.save
	getAlmacenes(true)
	render json: {NAlmacenes: bodegaGrupo7.cantAlmacenes, Nproductos: bodegaGrupo7.cantProductos}
end

def getAlmacenes(conCreacion)
	if(conCreacion)
		bodegaGrupo7 = Bodega.find_by name: 'grupo7'
		jsonAlmacenes = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/almacenes')
		jsonAlmacenes.each do |jsonAlmacen|
		    almacenCreado = Almacen.new(bodega: bodegaGrupo7, _id: jsonAlmacen['_id'], grupo: jsonAlmacen['grupo'], 
		    	pulmon: jsonAlmacen['pulmon'], despacho: jsonAlmacen['despacho'], recepcion: jsonAlmacen['recepcion'], 
		    	totalSpace: jsonAlmacen['totalSpace'], usedSpace: jsonAlmacen['usedSpace'])
		    almacenCreado.save
		    getSkusWithStock(almacenCreado, conCreacion)
		end	
  	else
	end
end

def getSkusWithStock(almacen, conCreacion)
	if(conCreacion)
		jsonSkusWithStock = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/skusWithStock', 
			generateParam('almacenId',almacen._id))
		jsonSkusWithStock.each do |jsonSku|
			skuFinded = jsonSku['_id']
			getStock(almacen, skuFinded, conCreacion)
		end
	else
	end
end

def getStock(almacen, sku, conCreacion)
	if(conCreacion)
		jsonProducts = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/stock', 
			generateParam('almacenId', almacen._id), generateParam('sku', sku))
		jsonProducts.each do |jsonProduct|
			productoCreado = Producto.new(almacen: almacen, 
				_id: jsonProduct['_id'].to_s, 
				sku: jsonProduct['sku'], 
				costo: jsonProduct['costo'], despachado: jsonProduct['despachado'], precio: jsonProduct['precio'], 
				grupo: jsonProduct['grupo'])
			productoCreado.save
		end
	else
	end	
end


end
