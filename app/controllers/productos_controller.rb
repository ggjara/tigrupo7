class ProductosController < ApplicationController
  def index
    @Productos = Bodega.first.productos
  end
end
