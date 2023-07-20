class SessionsController < ApplicationController
  include CategoryMethods
  before_action :require_login, only: [:edit, :update, :destroy]

  def index
    @all_comment_ranks = Question.joins(:question_answers).preload(:question_answers).group(:id).order('count(question_answers.id) desc')
    @post_like_ranks = Post.joins(:favorites).preload(:favorites).group(:id).order('count(favorites.id) desc')
    categories = Category.all.select(:id,:category) #全てのハッシュタグを取得
    category_count = CategoryQuestion.all.group(:category_id).count #中間テーブルのレコードをhashtag_id毎にグループ化し、数を取得(Viewにて数を表示したいため)
    @categories = []
    categories.each_with_index do |category| #普通にeach doでも大丈夫です。
      category = category.attributes #ハッシュに変換
      category["count"] = category_count[category["id"]] #countというkeyを増やし、中間テーブルの数の情報を格納する
        @categories << category #配列に格納
    end
    if @categories.length > 1
        @categories = @categories.sort{ |a,b| b["count"] <=> a["count"]} #表示はハッシュタグが使用されている投稿の多い順にする
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
    # @all_comment_ranks = Question.joins(:question_answers).group("question_answers.question_id").order('count(question_id) desc')
    # @post_like_ranks = Post.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
    # (Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
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
