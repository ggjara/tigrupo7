class Admin::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

def index
  render 'layouts/application'
end

#Retorna todas las OC luego de revisar FTP
def consultarFtp
  ordenesConsultadas= ConsultarPedidosFtp.new.consultarOcsFTP
  render json: ordenesConsultadas
end

#Inicia la bodega
def iniciarBodega
  desdeCero = true
  ib = Bodega.iniciarBodega(desdeCero)
  render json: ib
end

def actualizarBodega
  desdeCero = false
  ib = Bodega.iniciarBodega(desdeCero)
  render json: ib
end

#Controlador que recibe id prima y cantidad a producir
def producirPrimasSkuYCantidad
  sku = params[:id].to_s
  cantidad_lotes = params[:cantidad].to_i
  render json: ProducirMateriasPrimas.new(sku).producirCantidad(cantidad_lotes)
end

#Controlador que recibe id prima y manda a producir un lote
def producirPrimasSku
  sku = params[:id].to_s
  pm = ProducirMateriasPrimas.new(sku)
  render json: pm.producirCantidad(1)
end





def prueba
  render json: Bodega.first.saldo if not nil
end

end
