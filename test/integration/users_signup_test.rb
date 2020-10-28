require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar"} }
    end
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "TANAKA TARO",
                                         password: "password",
                                         email: "tanaka@example.org",
                                         password_confirmation: "password"} }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインする
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正の場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールが不正の場合
    get edit_account_activation_path(user.activation_token, email: "wrong@invalid.com")
    assert_not is_logged_in?
    # 有効なトークンの場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert flash.now
  end
end
