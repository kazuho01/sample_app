module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user) #log_inメソッドにuser（ログイン時に送ったメールとパスワード）を引数として渡す
    session[:user_id] = user.id # ユーザーIDをsessionのuser_idに代入（ログインIDの保持）
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログイン中のユーザー（current_user）を返す（いる場合）&記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      #raise  # 「raise」を置くことでわざとエラーをだす。もしテストがパスすれば、この部分がテストされていないことがわかる
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインをしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil? # current_user（ログインユーザー）がnilじゃ無いならtrue、それ以外はfalseを返す。!を先頭に付けることによって、否定演算子(not)を使い、本来ならnilならtrueの所をnilじゃないならtrueにしている。
  end

  #永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)  # sessionのユーザーIDを削除する
    @current_user = nil       # 現在のログインユーザー（一時的なcookie）をnil（空に）する
  end

end
