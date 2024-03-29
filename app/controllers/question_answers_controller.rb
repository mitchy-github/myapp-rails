class QuestionAnswersController < ApplicationController
  def create
    @question_answer = QuestionAnswer.new(question_answer_params)
    @question_answer.user_id = current_user.id
    @question_answer.question_id = params[:question_id]
    @question_answer.save!
    flash[:notice] = "コメントしました"
    redirect_to question_path(question_id)
  rescue StandardError
    @question = Question.find(params[:question_id])
    related_records = CategoryQuestion.where(question_id: @question.id).pluck(:category_id)
    categories = Category.all
    @categories = categories.select{ |category| related_records.include?(category.id) }
    @display_contents_question = @question.contents_question.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/, "")
    flash[:danger] = "空白、1000文字以上で回答することはできません"
    redirect_to question_path(question_id)
  end

  def destroy
    question_answer = QuestionAnswer.find_by(id: params[:id], question_id: question_id)
    unless question_answer.user_answer?(current_user)
      redirect_to question_path(question_id), alert: "許可されていないリクエストです", status: :unprocessable_entity and return
    end

    question_answer.destroy
    redirect_to question_path(question_id), notice: "コメントを解除しました", status: :see_other
  end

  private
    def question_answer_params
      params.require(:question_answer).permit(:answer_content)
    end

    def question_id
      @question_id ||= params[:question_id]
    end
end
