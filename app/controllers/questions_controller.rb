class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @test = "テストテキスト"
    # @questions = current_user.questions.all
    @questions = Question.all
    @categories = Category.all
  end

  def show
    @question_answer = QuestionAnswer.new
  end

  def new
    @categories = Category.all
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    @categories = Category.all
    @question.save!
      flash[:notice] = "成功！"
      redirect_to("/questions/new")
    rescue StandardError
      flash.now[:alert] = "失敗！"
      render "questions/new", status: :unprocessable_entity
  end

  def edit
    @categories = Category.all
  end

  def update
    # if @question.user_question?(current_user) && @question.update(question_params)
    #   flash[:notice] = "投稿内容を編集しました"
    #   redirect_to question_path(@question.id)
    # else
    #   # flash.now[:alert] = "失敗！"
    #   render "questions/edit", status: :unprocessable_entity
    # end
    unless @question.user_question?(current_user) && @question.update(question_params)
      render "questions/edit", status: :unprocessable_entity and return
    end

    flash[:notice] = "投稿内容を編集しました"
    redirect_to question_path(@question.id)
  end

  def destroy
    @question.destroy
    flash[:notice] = "成功！"
    redirect_to "/questions", status: :see_other
  end

private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_title, :contents_question, {:category_ids => []})
  end
end
