require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end


  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


  test "login with valid information" do
    get login_path  # ログインURL（/login）のnewアクションを取得
    post login_path, params: { session: { email:    @user.email,    # ログインURL（/login）のcreateアクションへデータを送り、paramsでsessionハッシュのemailに"michael"の（有効な）emailを渡す
                                          password: 'password' } }  # passwordに'password'を渡す。fixtureで定義した"michael"でログインするということ
    assert_redirected_to @user            # リダイレクト先が正しいかチェック
    follow_redirect!  # @userのURLにリダイレクト
    assert_template 'users/show'  # users/showで描画されていればtrue
    assert_select "a[href=?]", login_path, count: 0 # login_path（/login）がhref=/loginというソースコードで存在しなければtrue（0だから）
    assert_select "a[href=?]", logout_path  # logout_pathが存在していればtrue
    assert_select "a[href=?]", user_path(@user) # michaelのidを/user/:idとして受け取った値が存在していたらtrue
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
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

end
