class BodegasController < ApplicationController
#requestWeb(typeOfRequest, uri, *paramsRequest)
#generateParam(name, value)

def consultarInfo
	render json: Bodega.first
end

end