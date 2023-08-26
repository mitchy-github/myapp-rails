class QuestionsController < ApplicationController
  include CategoryMethods
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :edit, :update, :destroy]

  def index
    @questions = Question.includes(:user)
    @categories = Category.includes(:question)
    @category_questions = CategoryQuestion.includes(:question)
    # @user = User.find_by(id: @question.user_id)
    # @question = current_user.questions
    # @users = User.all
    # @all_comment_ranks = Question.find(QuestionAnswer.group(:question_id).order('count(question_id) desc').pluck(:question_id))
  end

  def show
    @user = User.find_by(id: @question.user_id)
    @question_answer = QuestionAnswer.new
    @question = Question.includes(:categories, :question_answers).find(params[:id])
    related_records = CategoryQuestion.where(question_id: @question.id).pluck(:category_id)
    categories = Category.all
    @categories = categories.select{ |category| related_records.include?(category.id) }
    @display_contents_question = @question.contents_question.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/, "")
  end

  def new
    @categories = Category.all
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    category = extract_category(@question.contents_question)
    @question.save!
      save_category(category, @question)
      flash[:notice] = "成功！"
      redirect_to questions_path

    rescue StandardError
      # flash.now[:alert] = "失敗！"
      render "questions/new", status: :unprocessable_entity
      # render new_question_path, status: :unprocessable_entity

    # ↓リファクタリングまえ↓
    # @question = Question.new(question_params)
    # @question.user_id = current_user.id
    # @categories = Category.all
    # @question.save!
    #   flash[:notice] = "成功！"
    #   redirect_to("/questions/new")
    # rescue StandardError
    #   flash.now[:alert] = "失敗！"
    #   render "questions/new", status: :unprocessable_entity
  end

  def edit
    @categories = Category.all
    @question = Question.find(params[:id])
  end

  def update
    unless logged_in? && @question.user_question?(current_user) && @question.update(question_params)
      render "questions/edit", status: :unprocessable_entity and return
    end

    @question = Question.find(params[:id])
    strong_paramater = question_params
    delete_records_related_to_category(params[:id])

    # @question.update(question_params)
    flash[:notice] = "投稿内容を編集しました"
    category = extract_category(@question.contents_question)
    save_category(category, @question)
    redirect_to question_path(@question.id)


    # if @question.user_question?(current_user) && @question.update(question_params)
    #   flash[:notice] = "投稿内容を編集しました"
    #   redirect_to question_path(@question.id)
    # else
    #   # flash.now[:alert] = "失敗！"
    #   render "questions/edit", status: :unprocessable_entity
    # end
    # unless @question.user_question?(current_user) && @question.update(question_params)
    #   render "questions/edit", status: :unprocessable_entity and return
    # end

    # flash[:notice] = "投稿内容を編集しました"
    # redirect_to question_path(@question.id)
    # end

    # if logged_in? && @question.user_question?(current_user) && @question.update(question_params)
    #   @question = Question.find(params[:id])
    #   strong_paramater = question_params
    #   delete_records_related_to_category(params[:id]) #こちらのメソッドで中間テーブルとハッシュタグのレコードを削除

    #   # @question.update(question_params)
    #   flash[:notice] = "投稿内容を編集しました"
    #   category = extract_category(@question.contents_question) #投稿よりハッシュタグを取得
    #   save_category(category,@question) #ハッシュタグの保存
    #   redirect_to question_path(@question.id)
    # else
    #   render "questions/edit", status: :unprocessable_entity
    # end
  end

  def destroy
    @question = Question.find_by(id: params[:id])
    @question.destroy
    delete_records_related_to_category(params[:id])
    flash[:notice] = "投稿を削除しました"
    redirect_to questions_path, status: :see_other

    # @question.destroy
    # flash[:notice] = "成功！"
    # redirect_to "/questions", status: :see_other
  end

private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_title, :contents_question, :best_answer_id)
  end
end
