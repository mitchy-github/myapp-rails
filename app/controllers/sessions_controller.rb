class SessionsController < ApplicationController
  include CategoryMethods
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
  end

  def new

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
