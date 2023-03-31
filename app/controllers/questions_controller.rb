class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @test = "テストテキスト"
    @questions = current_user.questions.all
    # @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @question_answer = QuestionAnswer.new
    # @question_answer.user_id = current_user.id
    # @question_answer.question_id = params[:question_id]
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    if @question.save
      flash[:notice] = "成功！"
      redirect_to("/questions/new")
    else
      flash.now[:alert] = "失敗！"
      render "questions/new", status: :unprocessable_entity
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      flash[:notice] = "投稿内容を編集しました"
      redirect_to("/questions/#{@question.id}")
    else
      # flash.now[:alert] = "失敗！"
      render"questions/edit", status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:notice] = "成功！"
    redirect_to "/questions", status: :see_other
  end

private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_title, :contents_question)
  end
end
