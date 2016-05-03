class Api::ApplicationController < ApplicationController
protect_from_forgery with: :null_session
respond_to :json

#Metodo de prueba
def index
	if( !Bodega.first.nil?)
		render json: {cantidadAlmacenes: Bodega.first.cantAlmacenes}
	else
		render json: 'Hola'
	end
end

#Consulta por SKU y retorna cantidad en bodega
#Si la Bodega no está iniciada, se inicia
def consultar
	skuAsked= params[:id].to_s
	bodegaGrupo7 = Bodega.find_by name: 'grupo7'
	if (bodegaGrupo7!=nil)
		cantDisponible = Bodega.checkStock(skuAsked)
		render json: {total: cantDisponible}
	else
		bodegaGrupo7 = Bodega.iniciarBodega
		cantDisponible = Bodega.checkStock(skuAsked)
		render json: {total: cantDisponible}
	end
end

#Recibe una OC con una id y la aceptamos o rechazamos

def recibirOc
	render json: {
		"aceptado":false,
		"idoc": params[:id]
	}
end

def recibirFactura
	render json: {
		"validado": false,
		"idfactura": params[:id]
	}
end

def recibirTrx
	render json: {
		"validado": false,
		"idtrx": params[:id]
	}
end

def recibirDespacho
	render json:{
		"validado": false
	}
	
end

#Metodo para retornar Json
def self.respond_to(*mimes)
include ActionController::RespondWith::ClassMethods
end

end
