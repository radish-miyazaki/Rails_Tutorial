require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar"} }
    end
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: { name: "TANAKA TARO",
                                         password: "password",
                                         email: "tanaka@example.org",
                                         password_confirmation: "password"} }
    end
    follow_redirect!
    assert_template 'users/show'
    assert flash.now
  end
end
