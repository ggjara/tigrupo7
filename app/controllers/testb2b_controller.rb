class Testb2bController < ApplicationController

def initialize
end

# Se llama a iniciar la venta con el id de la oc como parametro
# Chequeamos, validamos, si aceptamos procedemos a enviar la factura
# Recibimos la respuesta de la factura,
def iniciarVenta
  idOC = params[:id]
  if (ProveedorRecibirOc.new.responderOc(idOC))
    render ProveedorEnviarFactura.new.enviarFactura(idOC)
  else
    render json:false
  end
end

def finalizarVenta

end


end
