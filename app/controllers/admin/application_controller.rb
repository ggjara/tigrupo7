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
def iniciar
  ib = Bodega.iniciarBodega
  render json: ib
end

def producirPrimas
  sku = params[:id]
  ProducirMateriasPrimas.new(sku)
  render json: 

end

end
