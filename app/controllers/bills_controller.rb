class BillsController < ApplicationController
  def index
    @bills = Bill.all
    if(@bills)
    	@bills = @bills.where(despachada: true)
    end
  end

  def show
    @bill = Bill.find_by(:_id => params[:id].to_s)
  end
end
