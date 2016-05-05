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

#Muestra los clientes
def clientes
  clientes = Cliente.all
  render json: clientes
end

#Inicializa los clientes
def clientesIniciar
  clientes_list = [
  ["571262b8a980ba030058ab4f", "571262c3a980ba030058ab5b", "571262aaa980ba030058a147", 1],
  ["571262b8a980ba030058ab50", "571262c3a980ba030058ab5c", "571262aaa980ba030058a14e", 2],
  ["571262b8a980ba030058ab51", "571262c3a980ba030058ab5d", "0", 3],
  ["571262b8a980ba030058ab52", "571262c3a980ba030058ab5f", "0", 4],
  ["571262b8a980ba030058ab53", "571262c3a980ba030058ab61", "0", 5],
  ["571262b8a980ba030058ab54", "571262c3a980ba030058ab62", "0", 6],
  ["571262b8a980ba030058ab55", "571262c3a980ba030058ab60", "0", 7],
  ["571262b8a980ba030058ab56", "571262c3a980ba030058ab5e", "571262aaa980ba030058a31e", 8],
  ["0", "0", "0", 9],
  ["571262b8a980ba030058ab58", "571262c3a980ba030058ab63", "571262aaa980ba030058a40c", 10],
  ["571262b8a980ba030058ab59", "571262c3a980ba030058ab64", "0", 11],
  ["571262b8a980ba030058ab5a", "0", "0", 12]]

  puts "Creando Clientes"

  clientes_list.each do |_idGrupo, _idBanco, _idAlmacenRecepcion, grupo|
    if(Cliente.find_by(_idGrupo: _idGrupo)==nil)
      cliente = Cliente.create(_idGrupo: _idGrupo, _idBanco: _idBanco, _idAlmacenRecepcion: _idAlmacenRecepcion, grupo: grupo)
      cliente.save!
    end
  end 

  clientes = Cliente.all
  render json: clientes
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
