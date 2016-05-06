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
		render json: {total: cantDisponible}
	else
		bodegaGrupo7 = Bodega.iniciarBodega(true)
		cantDisponible = Bodega.checkStockTotal(skuAsked)
		render json: {total: cantDisponible}
	end
end

#Recibe una OC con una id y la aceptamos o rechazamos

def recibirOc
	idOC = params[:id]
  if (ProveedorRecibirOc.new.responderOc(idOC))
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
	idTrx = params[:id]
  idFactura = params[:idfactura]

	if(ProveedorRecibirTrx.new.recibirTrx(idTrx, idFactura))
		ocAsociada = Oc.find_by(_id: Factura.find_by(_id:idFactura).id_Oc)#RequestsFactura.new.obtenerFactura(idFactura)[:id_Oc])
    puts "Pago OK!"
		Thread.new do
			ProveedorDespacharProductos.new.despacharProductos(ocAsociada,false)
			ActiveRecord::Base.connection.close
		end

		render json: {
			"validado": true,
			"idfactura": params[:id]
		}
  else
		render json: {
			"validado": false,
			"idfactura": params[:id]
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
