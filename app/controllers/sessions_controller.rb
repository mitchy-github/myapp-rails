class SessionsController < ApplicationController
  include CategoryMethods
  # prepend_before_action :confirm_authenticity_token, only: :create
  # protect_from_forgery with: :null_session
  before_action :require_login, only: [:edit, :update, :destroy]

  def index
    @all_comment_ranks = Question.joins(:question_answers).preload(:question_answers).group(:id).order('count(question_answers.id) desc')
    @post_like_ranks = Post.joins(:favorites).preload(:favorites).group(:id).order('count(favorites.id) desc')
    categories = Category.all.select(:id, :category)
    category_count = CategoryQuestion.all.group(:category_id).count
    @categories = []
    categories.each_with_index do |category|
      category = category.attributes
      category["count"] = category_count[category["id"]]
        @categories << category
    end
    if @categories.length > 1
        @categories = @categories.sort{ |a, b| b["count"] <=> a["count"] }
    end
    # @user = User.find_by(id: params[:id])
    # @user = User.find_by(id: current_user.id)
    # @question = Question.find(params[:id])
    # @user = User.find_by(id: @question.user_id)
    # @users = User.all
    # @user = User.find_by(id: params[:id])
    # @posts = Post.all
    # @questions = Question.all
    # .includes(:user)
    # @categories = Category.all
    # @question = current_user
    # @question = User.questions
    # @category_questions = CategoryQuestion.all
    # @articles = Question.find(QuestionAnswer.group(:question_id).includes(:question).select(:question_id, 'count(*) as c').order(c: :desc).map{_1.question})
    # @all_comment_ranks = Question.having(id: QuestionAnswer.group(:question_id).order('count(question_id) desc').pluck(:question_id))
    # @all_comment_ranks = Question.joins(:question_answers).
    # group("question_answers.question_id").order('count(question_id) desc')
    # @post_like_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    # (Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end

  def new

  end

  def create
    # binding.pry
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
