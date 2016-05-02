class ProductosController < ApplicationController
  def show
    @Productos = Bodega.first.productos
  end
end
