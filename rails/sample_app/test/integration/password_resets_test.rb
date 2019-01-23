require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
  end

  test "password resets with invalid email" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path, params: { password_reset: { email: "" } }
    assert_not flash.empty?
    assert_template 'password_resets/new'
  end

  test "password resets with valid email and access password reset page" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path, params: { password_reset: { email: @user.email } }
    assert_not flash.empty?
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_url
    
    user = assigns(:user)
    # password_resets/${valid reset_token}/edit?email=
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    # by non-activated user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # password_resets/${invalid reset_token}/edit?email=${valid email}
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # password_resets/${valid reset_token}/edit?email=${valid email}
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password:        "foobaz",
        password_confirmation: "barquux" } }
    assert_select 'div#error_explanation'
    
    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password:        "",
        password_confirmation: "" } }
    assert_select 'div#error_explanation'

    patch password_reset_path(user.reset_token), params: { email: user.email,
      user: { password:        "foobaz",
        password_confirmation: "foobaz" } }
    assert is_logged_in?
    assert_not flash.empty?
    assert_nil @user.reload.reset_digest
    assert_redirected_to user
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params: { password_reset: { email: @user.email } }

    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params: { email: @user.email,
      user: { password:        "foobar",
        password_confirmation: "foobar" } }
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
