class SessionsController < ApplicationController
  include CategoryMethods
  before_action :require_login, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
    @categories = Category.all
    # @categories = current_user.category.all
    @category_questions = CategoryQuestion.all
    @question_objects = creating_structures(questions: @questions,category_questions: @category_questions,categories: @categories)
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url, notice: "ログインしました。"
    else
      flash.now[:danger] = "メールアドレスかパスワードが間違っています。"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, notice: "ログアウトしました。", status: :see_other
  end
end
