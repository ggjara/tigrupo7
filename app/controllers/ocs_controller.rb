class OcsController < ApplicationController
  def oc_enviadas
    @oc_enviadas = Oc.all.where(:cliente => '571262b8a980ba030058ab55')
  end

  def oc_recibidas
    @oc_recibidas = Oc.all.where(:proveedor => '571262b8a980ba030058ab55')
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
      if(@oc.proveedor == '571262b8a980ba030058ab55')
        return true
      else
        return false
      end
    else
      return false
    end
  end

end
