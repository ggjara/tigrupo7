

class FacebookController < ApplicationController
	skip_before_action :verify_authenticity_token


  def page_wall_post
    title = params[:title]
    page_link = params[:page_link]
    link_name = params[:link_name]
    description = params[:description]
    image_url = params[:image_url]
    success_msg = 'Article Posted'


    #Picking the graph api object from koala gem
    @graph = Koala::Facebook::API.new(ACCESS_TOKEN)
    @graph.put_wall_post(title, {
           name: link_name, description: description, picture: image_url, link: page_link
       })
    render text: success_msg
end




end

