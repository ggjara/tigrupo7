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
  ib = Bodega.iniciarBodega(true) #True porque se inicia
  
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
  #1. Actualizar Datos Bodega
  ib = Bodega.iniciarBodega(false) #False porque no se inicia, solo actualiza

  #3. Revisar FTP
  #ConsultarPedidosFtp.new.consultarOcsFTP

  #2. Mandar a producir si hay bajo Stock
  ProducirMateriasPrimas.new.producirStockBajo

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
  ["571262b8a980ba030058ab4f", "571262c3a980ba030058ab5b", "571262aaa980ba030058a147", 1],
  ["571262b8a980ba030058ab50", "571262c3a980ba030058ab5c", "571262aaa980ba030058a14e", 2],
  ["571262b8a980ba030058ab51", "571262c3a980ba030058ab5d", "571262aaa980ba030058a1f1", 3],
  ["571262b8a980ba030058ab52", "571262c3a980ba030058ab5f", "571262aaa980ba030058a240", 4],
  ["571262b8a980ba030058ab53", "571262c3a980ba030058ab61", "571262aaa980ba030058a244", 5],
  ["571262b8a980ba030058ab54", "571262c3a980ba030058ab62", "0", 6],
  ["571262b8a980ba030058ab55", "571262c3a980ba030058ab60", "0", 7],
  ["571262b8a980ba030058ab56", "571262c3a980ba030058ab5e", "571262aaa980ba030058a31e", 8],
  ["571262b8a980ba030058ab57", "571262c3a980ba030058ab66", "571262aaa980ba030058a3b0", 9],
  ["571262b8a980ba030058ab58", "571262c3a980ba030058ab63", "571262aaa980ba030058a40c", 10],
  ["571262b8a980ba030058ab59", "571262c3a980ba030058ab64", "571262aaa980ba030058a488", 11],
  ["571262b8a980ba030058ab5a", "571262c3a980ba030058ab65", "571262aba980ba030058a5c6", 12]
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

def agregarInfoDiaria
  Bodega.agregarInfoDiaria
end

end