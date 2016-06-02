class IniciarBodega < ApplicationController
def initialize(name)
	@nameBodega = name
  @cantAlmacenes = 0
end


#Inicia Bodega. Retorna Bodega con 'name': 'grupo7'.
def iniciarBodega
  Bodega.destroy_all
  Almacen.destroy_all
  Producto.destroy_all
  #Oc.destroy_all
  Stock.destroy_all
  @bodegaGrupo7 = Bodega.new(name: @nameBodega, cantAlmacenes: @cantAlmacenes)
  @bodegaGrupo7.save
  agregarSaldo
  iniciarAlmacenes(true)
  return @bodegaGrupo7
end

#Actualiza Bodega. Retorna Bodega con 'name': 'grupo7'.
def actualizarBodega
  if (Bodega.first!=nil)
    @bodegaGrupo7 = Bodega.first
    @bodegaGrupo7.almacenes.destroy_all
    Almacen.destroy_all
    Stock.destroy_all
    @bodegaGrupo7.save
    agregarSaldo
    iniciarAlmacenes(true)
    return @bodegaGrupo7
  else
    return false
  end
end

def agregarSaldo
  @bodegaGrupo7.saldo = RequestsBanco.new.obtenerCuenta(Cliente.find_by(grupo: 7)._idBanco)[:saldo].to_i
  @bodegaGrupo7.save
end

def iniciarAlmacenes(conCreacion)
  if(conCreacion)
    paramsAlmacenes = RequestsBodega.new.getAlmacenes
    paramsAlmacenes.each do |paramsAlmacen|
        almacenCreado = Almacen.new(paramsAlmacen)
        almacenCreado.bodega = @bodegaGrupo7
        almacenCreado.save
        iniciarSkusWithStock(almacenCreado, conCreacion)
    end 
  else
  end
end

def iniciarSkusWithStock(almacen, conCreacion)
  if(conCreacion)
    paramsSkusAndTotals = RequestsBodega.new.getSkusWithStock(almacen._id)
    paramsSkusAndTotals.each do |paramsSkuAndTotal|
      stockNuevo = Stock.new(sku: paramsSkuAndTotal[:sku].to_s, total: paramsSkuAndTotal[:total])
      stockNuevo.almacen = almacen
      stockNuevo.save
    end
  else
  end
end

#No nos sirve ahora

# def iniciarStock(almacen_id, sku, conCreacion)
#   if(conCreacion)
#     paramsProductos = RequestsBodega.new.getStock(almacen_id, sku, 200)
#     paramsProductos.each do |paramsProducto|
#       productoCreado = Producto.new(paramsProducto)
#       productoCreado.almacen = Almacen.where(_id: almacen_id).first
#       productoCreado.save
#     end
#   else
#   end 
# end

end