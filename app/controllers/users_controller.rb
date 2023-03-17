class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    if @user.save
      log_in @user
      redirect_to @user, notice: "新規登録完了しました。"
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.update(user_params)
      redirect_to user_url(@user), notice: "ユーザーアカウントを編集しました。"
    else
      render :edit, status: :unprocessable_entity # rails7 から必須のオプション
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url, notice: "登録解除しました。", status: :see_other
  end

  def guest_login
    if current_user
      redirect_to current_user, alert: "すでにログインしています"  # ログインしている場合はゲストユーザーを作成しない
    else
      user = User.guest_login
      log_in user
      redirect_to user, notice: "ゲストとしてログインしました"
    end
  end

private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :sex, :avatar, :birthday, :region, :email, :password, :password_confirmation)
  end
end
