class QueueController < ApplicationController
  protect_from_forgery with: :exception
  respond_to :json
  require 'queue_recibir.rb'

  def index
    render json: "hola"
  end

  def put
    QueueRecibir.new.send
    render json: "mandado"
  end

  def get
    render json: QueueRecibir.new.receive
  end

end
