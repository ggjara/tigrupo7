class QueueController < ApplicationController
  protect_from_forgery with: :exception
  respond_to :json
  require 'queue_recibir.rb'

  def index
    render json: "hola"
  end

  #para pruebas
  def put
    render json: QueueRecibir.new.send
  end

  def get
    render json: QueueRecibir.new.receive
  end

end
