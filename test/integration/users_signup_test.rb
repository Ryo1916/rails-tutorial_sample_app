require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  # 初期化しておかないと、並行して行われる他のテストでメールが配信されたときにエラーが発生
  def setup
    @non_activated_user = users(:non_activated)
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    # resources :userでなく、"post '/signup'"を利用することを検知するため
    # assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      # 以下のコードはルートが変更されていることを検知できない
      # signup_pathもusers_pathも両方存在するため、上記assert_selectが必要
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assignsメソッドで、対応するアクション内のインスタンス変数にアクセスできるようになる
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    # 有効化されてないので、ログインできていないことを確認
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
  
  test "valid signup test with non activated account" do
    log_in_as(@non_activated_user)
    assert_not @non_activated_user.activated?
    get users_path
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    get user_path(@non_activated_user)
    assert_redirected_to root_url
  end
end
