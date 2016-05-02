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
   @Bodega = Bodega.find_by name: 'grupo7'
  end

#Consulta por SKU y retorna cantidad en bodega
#Si la Bodega no está iniciada, se inicia
  def consultarProducto
    @skuAsked= params[:id]
    @bodegaGrupo7 = Bodega.find_by name: 'grupo7'
    if (@bodegaGrupo7!=nil)
      @cantDisponible = @bodegaGrupo7.productos.where(sku: @skuAsked).count
    else
      @bodegaGrupo7 = IniciarBodega.new('grupo7').iniciarBodega
      @cantDisponible = @bodegaGrupo7.productos.where(sku: @skuAsked).count
    end
  end

def  iniciarBodega
	ib = Bodega.iniciarBodega
	render json: ib
end

end