class Testb2bController < ApplicationController

def initialize
end

def iniciarVenta
  idOC = params[:id].to_s
  if (ProveedorRecibirOc.new.responderOc(idOC))
    render json: ProveedorEnviarFactura.new.enviarFactura(idOC)
  else
    render json:false
  end
end

def finalizarVenta
  idTrx = '572a5e42e3648d030036a5ff'
  idFactura = '572a5dc2e3648d030036a5e1'
  if(ProveedorRecibirTrx.new.recibirTrx(idTrx, idFactura))
    puts "Pago OK!"
    render json:ProveedorDespacharProductos.new.despacharProductos(idFactura,false)
  else
    render json: false
  end

end


end
