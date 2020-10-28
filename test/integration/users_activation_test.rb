require 'test_helper'

class UsersActivationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @non_activation_user = users(:bar)
  end

  test "index only activation user" do
    log_in_as(@user)
    get users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", user_path(@non_activation_user), count: 0
  end

  test "show only activated user" do
    log_in_as(@user)
    get user_path(@user)
    get user_path(@non_activation_user)
    assert_redirected_to root_path
  end
end
