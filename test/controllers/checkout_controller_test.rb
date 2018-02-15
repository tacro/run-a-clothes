require 'test_helper'

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get confirm" do
    get checkout_confirm_url
    assert_response :success
  end

end
