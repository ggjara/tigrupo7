class ConsultarPedidosFtp < ApplicationController






def initialize	
end

#Genera (Si no existe) una OC
def consultarOcsFTP
	idsOcsEnFtp = consultarPedidos
	if idsOcsEnFtp.count>=1
		idsOcsEnFtp.each do |id|
			actualizarOc(id)
		end
	end
	return Oc.all
end

private
#Revisa el FTP y retorna un arreglo con los _ids de las OCs que están
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
	  Timeout.timeout(400) do
	    sftp.connect! # Establish connection
	    sftp.dir.foreach("/pedidos") do |namePedido|
	    	if (namePedido.name!= '.' && namePedido.name != '..' && namePedido.name != 'leidos')
			file = sftp.download!('/pedidos/'<<namePedido.name)
		   	doc = Nokogiri::XML(file)
		   	pedidos.append(doc.css("id").map.first.children.text)
		   	sftp.rename('/pedidos/'<<namePedido.name, '/pedidos/leidos/'<<namePedido.name)
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
	return pedidos
end

#Revisa si existe la OC. Si no existe, la obtiene de otro metodo y después la crea.
def actualizarOc(id)
	if noExisteOc(id)
		paramsOc = RequestsBodega.new.obtenerOc(id)
		ocNueva = Oc.new(paramsOc)
		ocNueva.save
	end
end

#Revisa si existe una OC con el _id consultado
def noExisteOc(id)
	!Oc.find_by(_id: id).present?
end




end