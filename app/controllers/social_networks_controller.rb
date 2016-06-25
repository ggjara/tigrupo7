class SocialNetworksController < ApplicationController
  protect_from_forgery with: :exception
  helper_method :current_twitter_user
  skip_before_action :verify_authenticity_token
  
  def index
  end


# Method which combines post on facebook page and twitter account
# params = {tweet: {message: ,media: }}
  def publish

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.config.twitter_key
      config.consumer_secret     = Rails.application.config.twitter_secret
      config.access_token        = Rails.application.config.access_token
      config.access_token_secret = Rails.application.config.access_token_secret
    end
      tweet = params[:tweet]
      title = tweet['message']
      url = tweet['media']
      client.update_with_media(title, open(url))

      #Picking the graph api object from koala gem
    @graph = Koala::Facebook::API.new(Rails.application.config.facebook_access_token)
    @graph.put_wall_post(title, {
           link: url      #picture: image_url
       })


  end


end
