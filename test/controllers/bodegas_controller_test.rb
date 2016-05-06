require 'test_helper'

class BodegasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get initialize" do
    get :initialize
    assert_response :success
  end

  test "should get consultarInfo" do
    get :consultarInfo
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
