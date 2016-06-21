include Rails.application.routes.url_helpers

class FacebookController < ApplicationController
#   before_filter :parse_facebook_cookies

# def parse_facebook_cookies
# 	@oauth = Koala::Facebook::OAuth.new
# 	@oauth.url_for_oauth_code(:permissions => "manage_pages, publish_pages")
#   @facebook_cookies ||= .get_user_info_from_cookie(cookies)

#   # If you've setup a configuration file as shown above then you can just do
#   # @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
# end

# def initialize
  
#   @access_token = @facebook_cookies["access_token"]
#   @user_graph = Koala::Facebook::GraphAPI.new(@access_token)
#   # retrieve collection fo all your managed pages: returns collection of hashes with page id, name, category, access token and permissions
#   page_id = '1224405857569745'
#   @page_access_token = @user_graph.get_page_access_token(page_id)


#   #Picking the graph api object from koala gem
#   @graph = Koala::Facebook::API.new(@page_access_token)
  
# end





  def initialize
    #specify page access_token here
    #@access_token = 'EAACEdEose0cBANASs4rDZBm2cx46SfZCrp2Junf0RmRpX8z3byMVNevNuURWycmVp7joYcx00Q4H7ycmC2RUKPNGQpTNHfvvpEqHynguL9meIp8IJa4HiZBE8jGiPjKZAp3M52ESE75h9DIvSaU2r0fOkLBmNfs05rkYwPdw3gZDZD'
    
    @oauth = Koala::Facebook::OAuth.new('http://localhost:3000/')
    @oauth.url_for_oauth_code(:permissions => "publish_actions,manage_pages, publish_pages") # generate authenticating URL
	@user_access_token = @oauth.get_access_token(code) # fetch the access token once you have the code

	@user_graph = Koala::Facebook::API.new(@user_access_token)
	# retrieve collection fo all your managed pages: returns collection of hashes with page id, name, category, access token and permissions
	

	
	@page_access_token = @user_graph.get_page_access_token(PAGE_ID)


    #Picking the graph api object from koala gem
    @graph = Koala::Facebook::API.new(@page_access_token)
  end

  def page_wall_post
    title = params[:title]
    page_link = params[:page_link]
    link_name = params[:link_name]
    description = params[:description]
    image_url = params[:image_url]
    success_msg = 'Article Posted'

    begin
      #put_wall_post is method to post an article to the pages
      post_info = @graph.put_wall_post(title, {
          name: link_name, description: description, picture: image_url, link: page_link
      })
    rescue Exception => e
      success_msg = e.message
    end

    render text: success_msg
end

end