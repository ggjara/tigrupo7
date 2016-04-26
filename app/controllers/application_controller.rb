class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


def index
  render json: {Bienvenida: 'Bienvenido a la Home de nuestra pagina'}
end

#Metodo que Realiza una request.
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

#Genera una Instancia de Param
def generateParam(name, value)
  return Param.new(name: name, value: value)
end

end