class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


key = '1234'
signature = 'abcdef'


  def index

  	key = 'abcd12345'
	signature = 'GET534960ccc88ee69029cd3fb2'

	render json: {Bienvenida: hmac_sha1(signature, key)}
  end


  def hmac_sha1(data, secret)
  	require 'base64'
	require 'cgi'
	require 'openssl'
	require 'hmac-sha1'
	hmac = OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret.encode("ASCII"), data.encode("ASCII"))
	signature = Base64.encode64(hmac).chomp
	return signature
end

end