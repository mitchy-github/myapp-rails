class SessionsController < ApplicationController
  include CategoryMethods
  before_action :require_login, only: [:edit, :update, :destroy]

  def index
    # @user = User.find_by(id: params[:id])
    # @user = User.find_by(id: current_user.id)
    # @question = Question.find(params[:id])
    # @user = User.find_by(id: @question.user_id)
    # @users = User.all
    # @user = User.find_by(id: params[:id])
    @posts = Post.all
    @questions = Question.all
    # .includes(:user)
    @categories = Category.all
    # @question = current_user
    # @question = User.questions
    @category_questions = CategoryQuestion.all
    @question_objects = creating_structures(questions: @questions,category_questions: @category_questions,categories: @categories)
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path, notice: "ログインしました。"
    else
      flash.now[:danger] = "メールアドレスかパスワードが間違っています。"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path, notice: "ログアウトしました。", status: :see_other
  end
end
