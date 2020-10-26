ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  
  # test環境下でもapplication_helperを使えるように追加
  include ApplicationHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # test環境下でもlogged_in?と同じメソッドが使えるように定義
  # ただし、紛らわしいので別名とする
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Add more helper methods to be used by all tests here...
end
