module Spree
	class BillsController < Spree::StoreController
		respond_to :html  
	  def show
		@bill = Bill.find_by(_id: params[:id])
	  end

	  def error

	  end
	end
end


