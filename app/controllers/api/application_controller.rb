class Api::ApplicationController < ApplicationController
protect_from_forgery with: :null_session
respond_to :json

#Metodo de prueba
def index
	if( !Bodega.first.nil?)
		render json: {cantidadAlmacenes: Bodega.first.cantAlmacenes}
	else
		render json: 'Hola'
	end
end

#Consulta por SKU y retorna cantidad en bodega
#Si la Bodega no está iniciada, se inicia
def consultar
	skuAsked= params[:id].to_s
	bodegaGrupo7 = Bodega.first
	if (bodegaGrupo7!=nil)
		cantDisponible = Bodega.checkStockTotal(skuAsked)
		render json: {stock: cantDisponible, sku: skuAsked.to_i,}
	else
		bodegaGrupo7 = Bodega.iniciarBodega(true)
		cantDisponible = Bodega.checkStockTotal(skuAsked)
		render json: {stock: cantDisponible, sku: skuAsked.to_i,}
	end
end

#Recibe una OC con una id y la aceptamos o rechazamos

def recibirOc
	idOC = params[:id]
  	if (ProveedorRecibirOc.new.responderOc(idOC))
	  	#Si aceptamos la OC, entonces verificamos Stock, para ver si con el Stock Guardado pasamos el limite
	  	ProducirMateriasPrimas.new.producirStockBajo
		Thread.new do
			ProveedorEnviarFactura.new.enviarFactura(idOC)
			##simular respuesta
			#requestWeb('GET','http://localhost:3000/api/pagos/recibir/572c2641acbda70300e289c6?idfactura=572c2a57acbda70300e289d3')
			##end
			ActiveRecord::Base.connection.close
		end

	render json: {
		"aceptado":true,
		"idoc": params[:id]
	}

	else
		render json: {
			"aceptado":false,
			"idoc": params[:id]
		}
  	end
end

def recibirFactura
		render json: {
			"validado": false,
			"idtrx": params[:id]
		}
end

def recibirTrx
	idTrx = params[:idtrx]
  	idFactura = params[:idfactura]
	if(ProveedorRecibirTrx.new.recibirTrx(idTrx, idFactura))
		ocAsociada = Oc.find_by(_id: Factura.find_by(_id:idFactura).id_Oc)#RequestsFactura.new.obtenerFactura(idFactura)[:id_Oc])
		Thread.new do
			ProveedorDespacharProductos.new.despacharProductos(ocAsociada,false)
			ActiveRecord::Base.connection.close
		end

		render json: {
			"validado": true,
			"idtrx": idTrx.to_s
		}
  else
		render json: {
			"validado": false,
			"idtrx": idTrx.to_s
		}
  end
end

def recibirDespacho
	render json:{
		"validado": false
	}

end

#Metodo para retornar Json
def self.respond_to(*mimes)
include ActionController::RespondWith::ClassMethods
end

end
