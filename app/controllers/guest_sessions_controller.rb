class GuestSessionsController < ApplicationController
  def create
    user = User.find_or_create_by(email: "guest@exapmle.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "ゲストユーザー"
      user.sex = "1"
      user.birthday = "2020-01-01"
      user.region = "tokyo"
    end

    log_in(user)
    flash[:notice] = "ゲストユーザーとしてログインしました"
    redirect_to root_url
  end
end
