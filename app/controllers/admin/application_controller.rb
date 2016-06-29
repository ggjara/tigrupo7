class Admin::ApplicationController < ApplicationController
  protect_from_forgery with: :null_session

def index
  render 'layouts/application'
end

#Retorna todas las OC luego de revisar FTP
def consultarFtp
  #Antes de procesar las ordenes, se actualiza la Bodega
  IniciarBodega.new('grupo7').actualizarBodega
  #Se consulta las ordenes
  ordenesConsultadas= ConsultarPedidosFtp.new.consultarOcsFTP
  render json: ordenesConsultadas
end

#Inicializa la Bodega y Clientes.
def iniciarBodega
  Cliente.destroy_all
  #1. Crear clientes
  if(Cliente.all.count==0)
    clientesIniciar
  end
  #2. Crear Bodega
  Bodega.iniciarBodega(true) #True porque se inicia
  
  #3. Mandar a producir Stock si es Bajo
  ProducirMateriasPrimas.new.producirStockBajo
  render json: "Iniciada"
end

#Muestra los clientes
def clientes
  clientes = Cliente.all
  render json: clientes
end

def actualizarBodega
  Bodega.actualizarInfo
  render json: "Actualizada"
end

#Controlador que recibe id prima y cantidad de lotes a producir
def producirPrimasSkuYCantidad
  sku = params[:id].to_s
  cantidad_lotes = params[:cantidad].to_i
  render json: ProducirMateriasPrimas.new.producirCantidad(sku, cantidad_lotes)
end

#Vacia la Recepcion de Bodega
def vaciarRecepcionBodega
  ProveedorDespacharProductos.new.vaciarRecepcion
  render json: 'Almacen.find_by(recepcion: true).stocks'
end

#Inicializa los clientes
def clientesIniciar
clientes_list = [
  ["572aac69bdb6d403005fb042", "572aac69bdb6d403005fb04e", "572aad41bdb6d403005fb066", 1],
  ["572aac69bdb6d403005fb043", "572aac69bdb6d403005fb04f", "572aad41bdb6d403005fb0ba", 2],
  ["572aac69bdb6d403005fb044", "572aac69bdb6d403005fb050", "572aad41bdb6d403005fb1bf", 3],
  ["572aac69bdb6d403005fb045", "572aac69bdb6d403005fb051", "572aad41bdb6d403005fb208", 4],
  ["572aac69bdb6d403005fb046", "572aac69bdb6d403005fb052", "572aad41bdb6d403005fb278", 5],
  ["572aac69bdb6d403005fb047", "572aac69bdb6d403005fb053", "572aad41bdb6d403005fb2d8", 6],
  ["572aac69bdb6d403005fb048", "572aac69bdb6d403005fb054", "572aad41bdb6d403005fb3b9", 7],
  ["572aac69bdb6d403005fb049", "572aac69bdb6d403005fb056", "572aad41bdb6d403005fb416", 8],
  ["572aac69bdb6d403005fb04a", "572aac69bdb6d403005fb057", "572aad41bdb6d403005fb4b8", 9],
  ["572aac69bdb6d403005fb04b", "572aac69bdb6d403005fb058", "572aad41bdb6d403005fb542", 10],
  ["572aac69bdb6d403005fb04c", "572aac69bdb6d403005fb059", "572aad41bdb6d403005fb5b9", 11],
  ["572aac69bdb6d403005fb04d", "572aac69bdb6d403005fb05a", "572aad42bdb6d403005fb69f", 12]
]

  puts "Creando Clientes"

  clientes_list.each do |_idGrupo, _idBanco, _idAlmacenRecepcion, grupo|
    if(Cliente.find_by(_idGrupo: _idGrupo)==nil)
      cliente = Cliente.create(_idGrupo: _idGrupo, _idBanco: _idBanco, _idAlmacenRecepcion: _idAlmacenRecepcion, grupo: grupo)
      cliente.save!
    end
  end 

  clientes = Cliente.all
end


#Muestra los clientes
def clientes
  clientes = Cliente.all
  render json: clientes
end

#Muestra los almacenes
def almacenes
  almacenes = Almacen.all
  render json: almacenes
end

def facturas
  render json: Factura.all
end

def stocks
  stocks = Stock.all
  render json: stocks
end

def ocs
  ocs = Oc.all
  render json: ocs
end


end