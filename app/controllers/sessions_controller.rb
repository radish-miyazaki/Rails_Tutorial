class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      # ユーザーがアクティブかどうか検証
      if user.activated?
        # アクティブの場合のみログインを許可する
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        # 警告を出して、アクティブにするように促す
        message = "Account not activated. "
        message += "Check your email for the activation link"
        flash[:warning] = message
        redirect_to root_url
      end
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
