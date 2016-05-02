require 'test_helper'

class DocumentosControllerTest < ActionController::TestCase
  test "should get metodos" do
    get :metodos
    assert_response :success
  end

  test "should get flujos" do
    get :flujos
    assert_response :success
  end

end
