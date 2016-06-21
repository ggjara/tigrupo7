class TwitterController < ApplicationController
  protect_from_forgery with: :exception
  helper_method :current_twitter_user

  def index
  end


   def createTwitterSession
    user = TwitterUser.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroyTwitterSession
    session[:user_id] = nil
    redirect_to root_path
  end

  def newTweet
  end

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
