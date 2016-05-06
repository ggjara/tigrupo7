class StocksController < ApplicationController
  def index
    @Almacenes = Almacen.all
  end

  def show
  end
end
