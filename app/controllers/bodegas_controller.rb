class BodegasController < ApplicationController
#requestWeb(typeOfRequest, uri, *paramsRequest)
#generateParam(name, value)

def initialize
	cantAlmacenes=0
end

def iniciarBodega
	ib = Bodega.iniciarBodega
	render json: ib
end

end