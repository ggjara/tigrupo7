class SocialNetworksController < ApplicationController
  




  def index
  end


  




#   def signinfacebook
    
#     # @callback_url = SITE_URL+"facebookMethod/"
#     # session['oauth'] = Koala::Facebook::OAuth.new(FACEBOOK_ID, FACEBOOK_SECRET, @callback_url)
#     # @url=session['oauth'].url_for_oauth_code(:permissions => 'manage_pages, publish_stream')
#     # redirect_to @url

#         session[:oauth] = Koala::Facebook::OAuth.new('1210610395625557', 'a292334b1682c6456f556214f8a4fe43', 'http://localhost:3000/facebookMethod')
#         @auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"read_stream publish_stream")  
 
#         redirect_to @auth_url
    
#   end

# def facebookMethod

# @access_token_info = session['oauth'].get_access_token_info(params[:code])

# user = Koala::Facebook::API.new(@access_token_info['access_token'])

# page_token = user.get_page_access_token('1224405857569745')['access_token']
# page = Koala::Facebook::API.new(page_token)
# koala_page.put_connections(page_id, 'feed', :message => message, :picture => picture_url, :link => link_url)

# end






  # def postPromotion
  #   hash = JSON.parse(:promocion)
  #   if (hash["publicar"])
  #     message ="PROMOCION de "+ hash["inicio"] + " hasta " + hash["fin"] " sobre " + Product.find_by(:sku => hash["sku"]).name + " - PRECIO :  " + hash["precio"] + " - CODIGO : " + hash["codigo"]
  #     case hash["sku"]
  #       when 1
  #         media="carne-di-pollo-eurocarne.jpg"
  #       when 10
  #         media="marraqueta.jpg"
  #       when 23
  #         media="harina.jpg"
  #       when 39
  #         media="uva.jpg"
  #       else
  #         media=""
  #     end
  #     tweet = {message: message, media: media}
  #     generateParam(tweet, tweet)
  #     createTweet
  #   end
  # end



end
