module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user) #log_inメソッドにuser（ログイン時に送ったメールとパスワード）を引数として渡す
    session[:user_id] = user.id # ユーザーIDをsessionのuser_idに代入（ログインIDの保持）
  end

  # 現在ログイン中のユーザー（current_user）を返す（いる場合）
  def current_user
    if session[:user_id] # ログインユーザーがいたらtrue処理
      @current_user ||= User.find_by(id: session[:user_id]) # ログインユーザーがいればそのまま、いなければcookieのユーザーと同じidを持つユーザーをDBから探して@current_userに代入
    end
  end

  # ユーザーがログインをしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil? # current_user（ログインユーザー）がnilじゃ無いならtrue、それ以外はfalseを返す。!を先頭に付けることによって、否定演算子(not)を使い、本来ならnilならtrueの所をnilじゃないならtrueにしている。
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)  # sessionのユーザーIDを削除する
    @current_user = nil       # 現在のログインユーザー（一時的なcookie）をnil（空に）する
  end

end
