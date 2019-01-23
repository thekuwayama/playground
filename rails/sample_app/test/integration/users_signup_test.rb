require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action=?]', '/users'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
          email: "user@invalid",
          password:              "foo",
          password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation', count: 1
    assert_select 'div.field_with_errors', count: 2 * 4
    assert_not flash.key? :success
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
          email: "user@example.com",
          password:              "password",
          password_confirmation: "password" } }
    end
    # how many sent mail to activate account
    assert_equal 1, ActionMailer::Base.deliveries.size
    # get @user from UsersConroller#create
    user = assigns(:user)
    # then "Example User" is NOT activated
    assert_not user.activated?
    assert_not is_logged_in?
    # access /activation_path/invalid%20token?email=user%40example.com
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # access /activation_path/${valid token}?email=wrong
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # access /activation_path/${valid token}?email=user%40example.com
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert flash.key? :success
    assert_select 'div.alert-success', count: 1
  end
end
