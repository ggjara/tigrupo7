class ConsultarPedidosFtp< ApplicationController

def initialize	
end

#Genera (Si no existe) una OC
def consultarOcsFTP
	ordenesCompraFtpPorRecepcionar =Array.new
	idsOcsEnFtp = consultarPedidos
	if idsOcsEnFtp.count>=1
		idsOcsEnFtp.each do |id|
			ocCreada = actualizarOc(id)
			if ocCreada!=false
				ordenesCompraFtpPorRecepcionar.append(ocCreada)
			end
		end
	end

	#Cada OC nueva se procesa
	seAceptaPorLoMenos1 = false
	ordenesCompraFtpPorRecepcionar.each do |ordenCompra|
		if procesarOc(ordenCompra)
			seAceptaPorLoMenos1 = true
		end
	end

	#Si se acepto una OC, entonces se verifica stock y manda a producir
	if(seAceptaPorLoMenos1)
		ProducirMateriasPrimas.new.producirStockBajo
	end

	return ordenesCompraFtpPorRecepcionar
end

#Procesar OC: Verificar si la aceptamos. Generar Factura. Despachar productos
def procesarOc(ordenCompra)
	respuesta = ProveedorRecibirOcFtp.new.responderOc(ordenCompra)
	puts ':) Procesando OC: '<< ordenCompra._id.to_s
	if(respuesta) #Si la aceptamos, debemos ir a generar Factura
		puts ':) Aceptamos OC'
		if(ProveedorEnviarFacturaFtp.new.enviarFactura(ordenCompra._id)) #Si se genera la Factura, debemos despachar producto
			puts ':) Enviamos Factura'
			ProveedorDespacharProductos.new.despacharProductos(ordenCompra, true)
			puts ':) Despachamos productos'
			return respuesta
		end
	end

	return respuesta
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
		paramsOc = RequestsOc.new.obtenerOc(id)
		if paramsOc!=false
			ocNueva = Oc.new(paramsOc)
			ocNueva.save
			return ocNueva
		end
	end
	return false
end

#Revisa si existe una OC con el _id consultado
def noExisteOc(id)
	!Oc.find_by(_id: id).present?
end




end