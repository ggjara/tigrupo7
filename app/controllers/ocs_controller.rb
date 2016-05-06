class OcsController < ApplicationController
  def oc_enviadas
    @oc_enviadas = Oc.all.where(:cliente => Cliente.find_by(grupo: 7)._idGrupo)
  end

  def oc_recibidas
    @oc_recibidas = Oc.all.where(:proveedor => Cliente.find_by(grupo: 7)._idGrupo)
  end

  def factura
    @oc = Oc.find_by(:_id => params[:oc])
    @factura = Factura.find_by(:id_Oc => params[:oc].to_s)
  end

  def show
  end

  def esNuestra(id)
    @oc = Oc.find_by(_id: id)
    if @oc != nil
      if(@oc.proveedor == Cliente.find_by(grupo: 7)._idGrupo)
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
