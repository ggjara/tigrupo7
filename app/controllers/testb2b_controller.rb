class Testb2bController < ApplicationController

def initialize
end

def iniciarVenta
  idOC = params[:idoc].to_s
  if (ProveedorRecibirOc.new.responderOc(idOC))
    render json: ProveedorEnviarFactura.new.enviarFactura(idOC)
  else
    render json:false
  end
end

def finalizarVenta
  idTrx = '57297ed19fda6e0300481489'
  idFactura = '57297d629fda6e0300481483'
  factura = RequestsFactura.new.obtenerFactura(idFactura)#Factura.find_by(_id: idfactura)
  if(ProveedorRecibirTrx.new.recibirTrx(idTrx, factura))
    render json:ProveedorDespacharProductos.new.despacharProductos(factura[:id_Oc],false)
  else
    render false
  end

end


end
