class Api::ApplicationController < ApplicationController
protect_from_forgery with: :null_session
respond_to :json

  def self.respond_to(*mimes)
    include ActionController::RespondWith::ClassMethods
  end

  def index
  	render json: {Bienvenida: "Probando Home con API!"}
  end

  def prueba
  	render json: {Muestra: "Hli"}
  end

end
