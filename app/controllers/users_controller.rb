class UsersController < ApplicationController
  include CategoryMethods
  before_action :set_user, only: [:show, :edit, :update, :destroy, :likes]
  before_action :require_login, only: [:index, :show, :edit, :update, :destroy]

  def favorites
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    @favorite_posts = Post.find(favorites)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end

  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    @user.save!
      log_in @user
      redirect_to @user, notice: "新規登録完了しました"
    rescue StandardError
      render "new", status: :unprocessable_entity
  end

  def show
    @categories = current_user.questions.map(&:categories).flatten.uniq
    @question_answer = current_user.question_answers.map(&:question).flatten.uniq
    @user = User.includes(:posts, :questions).find(params[:id])
    @questions = @user.questions.page(params[:page]).reverse_order
    @following_users = @user.following_user
    @follower_users = @user.follower_user
  end

  def edit
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.email == "guest@exapmle.com"
      redirect_to root_path, alert: "ゲストユーザーは編集できません"
    elsif
      @user.update(user_params)
      redirect_to user_path(@user), notice: "ユーザーアカウントを編集しました"
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    if @user.guest_user?
      redirect_to root_path, alert: "ゲストユーザーは登録解除できません"
    else
      @user.destroy
      redirect_to root_path, notice: "登録解除しました", status: :see_other
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :sex, :avatar, :birthday, :region, :email, :password, :password_confirmation, :birthday_of_baby, :number_of_baby, :child_want, :childcare_start, :childcare_graduation_start, :childcare_graduation_end, :months_pregnant)
  end
end
