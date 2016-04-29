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
  @bodegaGrupo7 = Bodega.new(name: @nameBodega, cantAlmacenes: @cantAlmacenes)
  @bodegaGrupo7.save
  iniciarAlmacenes(true)
  return @bodegaGrupo7
end

def iniciarAlmacenes(conCreacion)
  if(conCreacion)
    paramsAlmacenes = RequestsBodega.new.getAlmacenes
    paramsAlmacenes.each do |paramsAlmacen|
        almacenCreado = Almacen.new(paramsAlmacen)
        almacenCreado.bodega = @bodegaGrupo7
        almacenCreado.save
        iniciarSkusWithStock(almacenCreado._id, conCreacion)
    end 
  else
  end
end

def iniciarSkusWithStock(almacen_id, conCreacion)
  if(conCreacion)
    paramsSkusAndTotals = RequestsBodega.new.getSkusWithStock(almacen_id)
    paramsSkusAndTotals.each do |paramsSkuAndTotal|
      iniciarStock(almacen_id, paramsSkuAndTotal[:sku], conCreacion)
    end
  else
  end
end

def iniciarStock(almacen_id, sku, conCreacion)
  if(conCreacion)
    paramsProductos = RequestsBodega.new.getStock(almacen_id, sku)
    paramsProductos.each do |paramsProducto|
      productoCreado = Producto.new(paramsProducto)
      productoCreado.almacen = Almacen.where(_id: almacen_id).first
      productoCreado.save
    end
  else
  end 
end

end