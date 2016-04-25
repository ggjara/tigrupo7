class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  def index
  	
	render json: {Bienvenida: generateAuthToken('GET'), Plural: 'Almacen'.pluralize}
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
  
#BODEGA
#Recibe el tipo de request y el valor de los params y entrega la authToken
  def generateAuthToken(typeOfRequest, *paramsRequest)
  	data = typeOfRequest
 	paramsRequest.each do |value|
   	 data= data << value
	end
	#Clave única Grupo7
	authToken= hmac_sha1(data, 'Z2ngwOHM%Jb.oMx')
	return authToken
  end

end