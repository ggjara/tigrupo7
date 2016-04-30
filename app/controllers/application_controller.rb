class ApplicationController < ActionController::Base
  require 'requests.rb'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

#Metodo de prueba
def index
  render json: RequestsBanco.new.obtenerCartola('1420070400', '1483228800', '571262c3a980ba030058ab60', 100)
end

#Retorna todas las OC luego de revisar FTP
def consultarFtp
  cp= ConsultarPedidosFtp.new
  render json: cp.consultarOcsFTP
end


#Metodo que Realiza una request y retorna el body de la respuesta Parseado
def requestWeb(typeOfRequest, uri, *paramsRequest)
  authKey = generateAuthToken(typeOfRequest, *paramsRequest)
  headers = { "Content-Type"=> "application/json", "Authorization"=> authKey}
  response
  query = Hash.new
  paramsRequest.each do |param|
   query.store(param.name, param.value)
  end

  if typeOfRequest.start_with?('GET')
    response =HTTParty.get(uri, :query => query, :headers => headers)
  elsif typeOfRequest.start_with? ('POST')
    response =HTTParty.post(uri, :body => query.to_json, :headers => headers)
  elsif typeOfRequest.start_with?('PUT')
    response=HTTParty.put(uri, :body => query.to_json, :headers => headers)
  elsif typeOfRequest.start_with?('DELETE')
    response=HTTParty.delete(uri, :body => query.to_json, :headers => headers)
  else
    response ='Blank'
  end

  return JSON.parse(response.body)
end

#Metodo que Realiza una request (sin params) y retorna el body de la respuesta Parseado
def requestWebWithoutParams(typeOfRequest, uri)
  headers = { "Content-Type"=> "application/json"}
  response
  query = Hash.new

  if typeOfRequest.start_with?('GET')
    response =HTTParty.get(uri, :query => query, :headers => headers)
  elsif typeOfRequest.start_with?('POST')
    response =HTTParty.post(uri, :body => query.to_json, :headers => headers)
  elsif typeOfRequest.start_with?('PUT')
    response =HTTParty.put(uri, :body => query.to_json, :headers => headers)
  elsif typeOfRequest.start_with?('DELETE')
    response =HTTParty.delete(uri, :body => query.to_json, :headers => headers)
  else
    response = "Blank"
  end

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

#Retorna una Instancia de Param con los params 'name' y 'value'
def generateParam(name, value)
  return Param.new(name: name, value: value)
end

private
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


end
