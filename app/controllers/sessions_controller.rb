class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase) #paramsハッシュで受け取ったemail値を小文字化して、email属性に渡してUserモデルから同じemailの値のuserを探して、user変数に代入
        # 上記のparams[:session]を細かく見ると → { session: { params: "foobar", email: "user@example.com"} }
    if @user && @user.authenticate(params[:session][:password]) #user変数がDBに存在し（&&で判別）、尚且つparamsハッシュを受け取ったpassword値とuserのemail値が同じであればtrue
      log_in @user #session_helperのlog_inメソッドを実行し、sessionメソッドのuser_id（ブラウザに一時coolieとして保持）にidを送る
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user 
    else
      flash.now[:danger] = "メールアドレス/パスワードが間違えています"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?   #ユーザーが（別タブなどで開いている状態で）ログインしていたらログアウトする
    redirect_to root_url    #ホームへリダイレクトする
  end

end
