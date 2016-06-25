class SocialNetworksController < ApplicationController
  protect_from_forgery with: :exception
  helper_method :current_twitter_user
  skip_before_action :verify_authenticity_token
  
  def index
  end

# Method used to enter manually parameters {tweet: {message: message,media: media}}
  def newPost
  end

# Method which combines post on facebook page and twitter account
  def publish
    page_wall_post
    createTweet
  end

# Method to post on facebook
  def page_wall_post
    tweet = params[:tweet]
    title = tweet['message']
    page_link = tweet['media']
    # I'm not sure about what facebook means with "page_link" and "image_url". 
    # To post an image of the internet thanks to its complete URL, page_link works and not image_url.
    # To switch :
                                # image_url = tweet['media']
    
    #Picking the graph api object from koala gem
    @graph = Koala::Facebook::API.new(ACCESS_TOKEN)
    @graph.put_wall_post(title, {
           link: page_link      #picture: image_url
       })
  end

# Method to create a twitter session (user = Tigrupo7Com)
  def createTwitterSession
    user = TwitterUser.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to '/social'
  end

#Method to destroy a twitter session
  def destroyTwitterSession
    session[:user_id] = nil
    redirect_to '/social'
  end

# Method to post on twitter account logged in
  def createTweet
    current_twitter_user.tweet(twitter_params)
  end

   def twitter_params
     params.require(:tweet).permit(:message, :media)
   end

  def current_twitter_user
    @current_twitter_user ||= TwitterUser.find(session[:user_id]) if session[:user_id]
  end

end
