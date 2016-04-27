class ConsultarPedidosFtp < ApplicationController
def initialize(params)
	
end

def consultarPedidos
	require 'net/ftp'
	require 'nokogiri'
	require 'net/sftp'
	require 'net/ssh'

	@host = "mare.ing.puc.cl"
	@user = "integra7"
	@password = "sFwhHaZE"
	pedidos =Array.new

	begin

	  # Instance SSH/SFTP session :
	  session = Net::SSH.start(@host, @user, password: @password, port: 22)
	  sftp = Net::SFTP::Session.new(session)

	  # Always good to timeout :
	  Timeout.timeout(100) do
	    sftp.connect! # Establish connection
	    sftp.dir.foreach("/pedidos") do |namePedido|
	    	if (namePedido.name!= '.' && namePedido.name != '..')
			file = sftp.download!('/pedidos/'<<namePedido.name)
		   	doc = Nokogiri::XML(file)
		   	pedidos.append(doc.css("id").map.first.children.text)
		   end
		end
	  end

	rescue Timeout::Error => e
	  # Do some custom logging
	  render json: {error: e.message} 

	ensure
	  # Close SSH/SFTP session
	  sftp.close_channel unless sftp.nil? # Close SFTP
	  session.close unless session.nil? # Then SSH
	end
	#Crear o no OCs
	pedidos.each do |pedido|
		actualizarOcs(pedido)
	end
end


def actualizarOc(pedido)
	if noExisteOc(pedido)
		paramsOc = obtenerOc
		ocNueva = Oc.new(paramsOc)
		ocNueva.save
	end
end


def obtenerOc(id)
	jsonResponse = requestWebWithoutParams('GET', ('http://mare.ing.puc.cl/oc/obtener/'<<id)).first
	paramsOc = { _id: jsonResponse['_id'],
				cliente: jsonResponse['cliente'],
				proveedor: jsonResponse['proveedor'],
				sku: jsonResponse['39'],
				fechaDespachos: jsonResponse['fechaDespachos'],
				fechaEntrega: jsonResponse['fechaEntrega'],
				precioUnitario: jsonResponse['precioUnitario'],
				cantidadDespachada: jsonResponse['cantidadDespachada'],
				cantidad: jsonResponse['cantidad'],
				canal: jsonResponse['canal'],
				fechaCreacion: jsonResponse['created_at'],
				estado: jsonResponse['estado']}
	return paramsOc
end

def noExisteOc(id)
	!Ocs.find_by(_id: id).present?
end

#1. Metodo que recibe todos los XML.

#2. Metodo que analiza un XML. 
#Si no existe la OC, se cre.
#Si existe la OC, no se hace nada

#3. Método para crear OC

end