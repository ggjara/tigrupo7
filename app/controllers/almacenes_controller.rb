class AlmacenesController < ApplicationController
  def show
    @Almacenes = Bodega.first.almacenes
  end
end
