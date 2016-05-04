class ClienteRecibirFactura < ApplicationController

def initialize
end

#crear factura DB
#ver que sea para nosotros
#comparar con oc
#marcar como pagada pagarFactura
#hacer transferencia
def recibirFactura(id_factura)
  facturaServer = crearFacturaDB(id_factura)
  if(validarFactura(facturaServer)!=false)
    pagarFactura
    hacerTransferencia
    actualizarCuentaDB
  end
end

def crearFacturaDB(id_factura)
  paramsFactura = RequestsFactura.new.obtenerFactura(id_factura)
  Facturas.new(paramsFactura)
  return paramsFactura
end

def validarFactura(factura)
  ocAsociada = RequestsOc.new.obtenerOc(factura[:id_Oc])
  if (factura[:cliente]!= '571262b8a980ba030058ab55')
    return false
  elsif (factura[:id])

  end
end

end
