class BiFinancierosController < ApplicationController
  def index
    @facturas = Factura.all.where('created_at > ?', 7.days.ago)
    @boletas = Bill.all.where('created_at > ?', 7.days.ago)
    @facturasFTP = @facturas.where(cliente: "internacional")
    @facturasB2Be = @facturas.where.not(cliente: "internacional", cliente: Cliente.find_by(grupo: 7)._idGrupo)
    @facturasB2Br = @facturas.where.not(cliente: "internacional", proveedor: Cliente.find_by(grupo: 7)._idGrupo)
    @saldos = Infosaldo.order(:fecha)

  end

  def show
    @transacciones = Trx.where(fechaCreacion: DateTime.parse(params[:id]).beginning_of_day..DateTime.parse(params[:id]).end_of_day)
  end
end
