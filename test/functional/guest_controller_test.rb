require 'test_helper'

class GuestControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get party" do
    get :party
    assert_response :success
  end

  test "should get payment" do
    get :payment
    assert_response :success
  end

  test "should get thanks" do
    get :thanks
    assert_response :success
  end

end
