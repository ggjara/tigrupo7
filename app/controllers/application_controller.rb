class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


def index
  render json: {Bienvenida: 'Bienvenido a la Home de la página'}
end

#Metodo que Realiza una request y retorna el body de la respuesta Parseado
def requestWeb(typeOfRequest, uri, *paramsRequest)
  authKey = generateAuthToken(typeOfRequest, *paramsRequest)
  headers = { "Content-Type"=> "application/json", "Authorization"=> authKey} 
  
  query = Hash.new
  paramsRequest.each do |param|
   query.store(param.name, param.value)
  end
  
  response =HTTParty.get(uri, :query => query, :headers => headers)
  return JSON.parse(response.body)   
end

#Recibe el tipo de request y el valor de los params y entrega la authToken
def generateAuthToken(typeOfRequest, *paramsRequest)
	data = typeOfRequest
	paramsRequest.each do |param|
 	 data= data << param.value.to_s
  end
  #Clave única Grupo7
  authToken= 'INTEGRACION grupo7:' << hmac_sha1(data, 'Z2ngwOHM%Jb.oMx')
  return authToken
  end

#Recibe un data y una key secret y retorna un procesado de HMAC-SHA1 en Base64
def hmac_sha1(data, secret)
  require 'base64'
  require 'cgi'
  require 'openssl'
  require 'hmac-sha1'
  hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret.encode("ASCII"), data.encode("ASCII"))
  signature = Base64.encode64(hmac).chomp
  return signature
end

#Retorna una Instancia de Param con los params 'name' y 'value'
def generateParam(name, value)
  return Param.new(name: name, value: value)
end

#Inicia Bodega. Retorna Bodega con 'name': 'grupo7'.
def iniciarBodega
  Bodega.destroy_all
  Almacen.destroy_all
  Producto.destroy_all
  bodegaGrupo7 = Bodega.new(name: 'grupo7')
  bodegaGrupo7.save
  getAlmacenes(true)
  return bodegaGrupo7
end

def getAlmacenes(conCreacion)
  if(conCreacion)
    bodegaGrupo7 = Bodega.find_by name: 'grupo7'
    jsonAlmacenes = requestWeb('GET', 'http://integracion-2016-dev.herokuapp.com/bodega/almacenes')
    jsonAlmacenes.each do |jsonAlmacen|
        almacenCreado = Almacen.new(
          bodega: bodegaGrupo7, 
          _id: jsonAlmacen['_id'], 
          grupo: jsonAlmacen['grupo'], 
          pulmon: jsonAlmacen['pulmon'], 
          despacho: jsonAlmacen['despacho'], 
          recepcion: jsonAlmacen['recepcion'], 
          totalSpace: jsonAlmacen['totalSpace'], 
          usedSpace: jsonAlmacen['usedSpace'])
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
      productoCreado = Producto.new(
        almacen: almacen, 
        _id: jsonProduct['_id'].to_s, 
        sku: jsonProduct['sku'], 
        costo: jsonProduct['costo'], 
        despachado: jsonProduct['despachado'], 
        precio: jsonProduct['precio'], 
        grupo: jsonProduct['grupo'])
      productoCreado.save
    end
  else
  end 
end


end