require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get initialize" do
    get :initialize
    assert_response :success
  end

  test "should get page_wall_post" do
    get :page_wall_post
    assert_response :success
  end

end
