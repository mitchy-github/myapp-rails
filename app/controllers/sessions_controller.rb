class SessionsController < ApplicationController
  before_action :require_login, only: [:edit, :update, :destroy]

  def index
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'メールアドレスかパスワードが間違っています。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to sessions_path, status: :see_other
  end
end
