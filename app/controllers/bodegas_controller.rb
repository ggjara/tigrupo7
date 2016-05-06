class BodegasController < ApplicationController
  #requestWeb(typeOfRequest, uri, *paramsRequest)
  #generateParam(name, value)

def initialize
  cantAlmacenes=0
end

def consultarInfo
  render json: Bodega.first
end

def show
   @Productos= Bodega.first.productos
end

end