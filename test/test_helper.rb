require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include ApplicationHelper

  # logged_in?メソッド（ヘルパーメソッド）がテストから呼び出せないため必要
  def is_logged_in?
    # テストユーザーがログイン中の場合にtrueを返す
    !session[:user_id].nil?
  end
end
