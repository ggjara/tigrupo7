class BiLogisticaController < ApplicationController
  def index
    @Almacenes = Bodega.first.almacenes
  end
end
