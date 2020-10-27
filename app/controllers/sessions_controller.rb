class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user

    else
      # flashメッセージを表示する
      flash.now[:danger] = "invalid email / password combnation"
      render 'new'
    end
  end



  def destroy
    log_out if logged_in? # ログインしている場合にかぎりlog_outを呼び出す
    redirect_to root_url
  end
end
