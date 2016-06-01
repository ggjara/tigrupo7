class BillsController < ApplicationController
  def index
    @bills = Bill.all
  end

  def show
    @bill = Bill.find_by(:_id => params[:id].to_s)
  end
end
