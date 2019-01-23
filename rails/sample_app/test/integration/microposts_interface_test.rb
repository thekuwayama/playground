require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'ul.pagination', count: 1
    assert_select 'input[type=file]'
    # invalid micropost
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # valid micropost
    content = "This micropost really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { 
          content: content,
          picture: picture } }
    end
    assert @user.microposts.first.picture?
    # assert_redirected_to root_path
    follow_redirect!
    assert_match content, response.body
    # delete micropost
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.page(1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # no delete link with wrong user
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    # Michael has posted many micropost
    log_in_as(@user)
    get root_path
    assert_match %r{\d+ microposts}, response.body
    # Malory has NOT posted microposts yet
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    # Malory has posted a micropost
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "1 micropost", response.body
  end
end
