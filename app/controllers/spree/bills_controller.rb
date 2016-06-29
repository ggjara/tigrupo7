module Spree
	class BillsController < Spree::StoreController
		respond_to :html  
	  def show
		@bill = Bill.find_by(_id: params[:id])
		
		if !@bill.despachada
			Thread.new do
				pp = ProveedorDespacharProductosBoleta.new
				pp.despacharProductos(@bill.sku, @bill.cantidad, @bill.direccion, @bill)
				@bill.despachada=true
				@bill.save
			end
		end
		
	  end

	  def error
	  	@bill = Bill.find_by(_id: params[:id])
	  	@idBoleta= @bill._id
	  	@bill.delete
	  end
	end
end


