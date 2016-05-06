class FacturasController < ApplicationController
  def index
  end

  def show
    @factura = Factura.find_by(:_id => params[:id].to_s)
  end
end
