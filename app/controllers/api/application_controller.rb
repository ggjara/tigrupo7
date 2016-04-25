class Api::ApplicationController < ApplicationController
protect_from_forgery with: :null_session
respond_to :json

  def self.respond_to(*mimes)
    include ActionController::RespondWith::ClassMethods
  end

  def index
  	render json: {Bienvenida: "Probando Home con API!"}
  end

def consultar
	skuAsked= params[:id]
	bodegaGrupo7 = Bodega.find_by name: 'grupo7'
	cantDisponible = bodegaGrupo7.productos.where(sku: skuAsked).count
	render json: {Sku: cantDisponible}
end


end
