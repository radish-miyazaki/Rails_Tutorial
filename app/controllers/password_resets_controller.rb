class PasswordResetsController < ApplicationController
  
  before_action :get_user,    only: [:edit, :update]
  before_action :valid_user,  only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update] # 有効期限を確認する

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  def edit
  end

  def update
    # 新しいパスワードが空の場合
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    # 新しいパスワードがバリデーションに引っかからない場合
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:succress] = "Password has been reset."
      redirect_to @user
    # 無効なパスワードの場合
    else
      render 'edit'
    end
  end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  # 有効期限を確認する
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    end
  end

  # strongparams
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
