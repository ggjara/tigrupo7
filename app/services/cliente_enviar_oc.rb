class ClienteEnviarOc < ApplicationController

def initialize
end

#Generamos los parametros para crear la oc en el sistema,
#luego, con esta, creamos una en el DB
def enviarOc(cantidad, sku, proveedor, precioUnitario,notas,fechaEntrega)
  if(validarOC(cantidad, precioUnitario))
    paramsOc = generarParametros(cantidad, sku, proveedor, precioUnitario,notas,fechaEntrega)
    ocSistema = RequestsOc.new.crearOc(paramsOc)
    ocDB = OC.new(ocSistema)
    ocDB.save
    #Reservar plata para evita comprar mas de lo que tenemos?
    return true
  else
    return false
  end
end

def validarOC(cantidad, precioUnitario)
  montoCuenta = RequestsBanco.new.obtenerCuenta("571262c3a980ba030058ab60")['saldo']
  montoDisponible = montoCuenta-montoReservado
  monotRequerido = cantidad * precioUnitario
  if(monotRequerido>montoCuenta)
    return false
  else
    return true
  end
end

def generarParametros(cantidad, sku, proveedor, precioUnitario,notas,fechaEntrega)
  paramsOc = { canal: "b2b",
    cantidad: cantidad,
    sku: sku,
    proveedor: proveedor,
    precioUnitario: precioUnitario,
    notas: notas,
    fechaEntrega: fechaEntrega,
    cliente: "571262b8a980ba030058ab55"}
  return paramsOc
end

end
