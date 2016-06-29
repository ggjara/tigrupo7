class PromocionesController < ApplicationController
  def index
    @promociones = AppPromotion.all
  end
end
