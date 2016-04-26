class Api::ApplicationController < ApplicationController
protect_from_forgery with: :null_session
respond_to :json

  def self.respond_to(*mimes)
    include ActionController::RespondWith::ClassMethods
  end

  def index
  	render json: (Bodega.find_by name: 'grupo7').almacenes
  end

#Consulta por SKU y retorna cantidad en bodega
#Si la Bodega no está iniciada, se inicia
def consultar
	skuAsked= params[:id]
	bodegaGrupo7 = Bodega.find_by name: 'grupo7'
	if (bodegaGrupo7!=nil)
		cantDisponible = bodegaGrupo7.productos.where(sku: skuAsked).count
		render json: {sku: cantDisponible}
	else
		bodegaGrupo7 = IniciarBodega.new({nameBodega: 'grupo7'}).iniciarBodega
		cantDisponible = bodegaGrupo7.productos.where(sku: skuAsked).count
		render json: {sku: cantDisponible}
	end
end


end
