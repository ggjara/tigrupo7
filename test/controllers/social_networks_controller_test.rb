require 'test_helper'

class SocialNetworksControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get createTwitterSession" do
    get :createTwitterSession
    assert_response :success
  end

  test "should get destroyTwitterSession" do
    get :destroyTwitterSession
    assert_response :success
  end

  test "should get newTweet" do
    get :newTweet
    assert_response :success
  end

  test "should get createTweet" do
    get :createTweet
    assert_response :success
  end

end
