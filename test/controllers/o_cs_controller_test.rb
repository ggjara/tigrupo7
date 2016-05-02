require 'test_helper'

class OCsControllerTest < ActionController::TestCase
  test "should get despachos" do
    get :despachos
    assert_response :success
  end

  test "should get facturas" do
    get :facturas
    assert_response :success
  end

  test "should get pagosAsociados" do
    get :pagosAsociados
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
