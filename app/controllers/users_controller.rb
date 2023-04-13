class UsersController < ApplicationController
  include CategoryMethods
  before_action :set_user, only: [:show, :edit, :update, :destroy ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:user][:avatar])
    @user.save!
      log_in @user
      redirect_to @user, notice: "新規登録完了しました。"
    rescue StandardError
      render "new", status: :unprocessable_entity
  end

  def show
    @questions = Question.all
    @categories = Category.all
    @category_questions = CategoryQuestion.all
    @question_objects = creating_structures(questions: @questions,category_questions: @category_questions,categories: @categories)
  end

  def edit
  end

  def update
    @user.avatar.attach(params[:user][:avatar]) if @user.avatar.blank?
    if @user.email == "guest@exapmle.com"
      redirect_to root_url, alert: "ゲストユーザーは編集できません。"
    elsif
      @user.update(user_params)
      redirect_to user_url(@user), notice: "ユーザーアカウントを編集しました。"
    else
      render "edit", status: :unprocessable_entity # rails7 から必須のオプション
    end
  end

  def destroy
    if @user.guest_user?
      redirect_to root_url, alert: "ゲストユーザーは登録解除できません。"
    else
      @user.destroy
      redirect_to root_url, notice: "登録解除しました。", status: :see_other
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
