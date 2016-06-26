require 'test_helper'

class TwitterControllerTest < ActionController::TestCase
  test "should get createTwitterSession" do
    get :createTwitterSession
    assert_response :success
  end

  test "should get destroyTwitterSession" do
    get :destroyTwitterSession
    assert_response :success
  end

  test "should get createTweet" do
    get :createTweet
    assert_response :success
  end

  test "should get newTweet" do
    get :newTweet
    assert_response :success
  end

  test "should get twitter_params" do
    get :twitter_params
    assert_response :success
  end

  test "should get current_twitter_user" do
    get :current_twitter_user
    assert_response :success
  end

end
