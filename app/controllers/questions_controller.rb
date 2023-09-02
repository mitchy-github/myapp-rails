class QuestionsController < ApplicationController
  include CategoryMethods
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :edit, :update, :destroy]

  def index
    @questions = Question.includes(:user)
    @categories = Category.includes(:question)
    @category_questions = CategoryQuestion.includes(:question)
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
      render "questions/new", status: :unprocessable_entity
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

    flash[:notice] = "投稿内容を編集しました"
    category = extract_category(@question.contents_question)
    save_category(category, @question)
    redirect_to question_path(@question.id)
  end

  def destroy
    @question = Question.find_by(id: params[:id])
    @question.destroy
    delete_records_related_to_category(params[:id])
    flash[:notice] = "投稿を削除しました"
    redirect_to questions_path, status: :see_other
  end

private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_title, :contents_question, :best_answer_id)
  end
end
