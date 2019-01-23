require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    log_in_as(@user, password: "")
    assert_template 'sessions/new'
    assert flash.key? :danger

    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    assert_template 'sessions/new'
    log_in_as(@user)
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login with valid information followed by logout" do
    get login_path
    log_in_as(@user)
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
   
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0 
  end

  test "login with valid information followed by logout twice" do
    get login_path
    log_in_as(@user)
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
   
    delete logout_path # click `Logout`
    assert_not is_logged_in?
    assert_redirected_to root_url

    delete logout_path # click `Logout`, 2nd, using other tab
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0 
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_path

    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

  test "successful redirect to index with friendly forwarding" do
    get users_path
    assert_redirected_to '/login'
    log_in_as(@user)
    assert_redirected_to users_path
    assert_not flash.empty?
  end
end
