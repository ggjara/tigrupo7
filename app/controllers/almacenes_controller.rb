class AlmacenesController < ApplicationController
  def index
    @Almacenes = Bodega.first.almacenes
  end
end
