class ProducirMateriasPrimas < ApplicationController
def initialize(sku)
  @sku =sku 
end


def producirCantidad(cantidad)
  return 'Hola' <<@sku
end

def hayPlataProducirCantidad(cantidad)

end