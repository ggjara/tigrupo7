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
  #2. Mandar a producir si hay bajo Stock
  ProducirMateriasPrimas.new.producirStockBajo
  #3. Revisar FTP
  ConsultarPedidosFtp.new.consultarOcsFTP

  #Si tenemos ordenes de Compra llegadas por FTP que no se han analizado
  ocCreadasFtp = Oc.where(cliente: "internacional", estado: 'creada')
  seAceptaPorLoMenos1 = false
  if(ocCreadasFtp.count>0)
    ocCreadasFtp.each do |ocCreada|
      if ConsultarPedidosFtp.new.procesarOc(ocCreada)
        se seAceptaPorLoMenos1 =true
      end
    end
  end

  #Si se acepta por lo menos 1, se manda a producir si es necesario
  if(seAceptaPorLoMenos1)
    #2. Mandar a producir si hay bajo Stock
    ProducirMateriasPrimas.new.producirStockBajo
  end

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
  render json: Almacen.find_by(recepcion: true).stocks
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
end

end
