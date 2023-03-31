class QuestionAnswersController < ApplicationController
  def create
    @question_answer = QuestionAnswer.new(question_answer_params)
    @question_answer.user_id = current_user.id
    @question_answer.question_id = question_id
    @question_answer.save!
    flash[:notice] = "コメントしました。"
    redirect_to question_path(question_id)
  rescue StandardError
    @question = Question.find(question_id)
    render "questions/show", status: :unprocessable_entity
  end

  def destroy
    question_answer = QuestionAnswer.find_by(id: params[:id],question_id: question_id)
    # if question_answer.user_answer?(current_user)
    #   question_answer.destroy
    #   redirect_to question_path(question_id), notice: "コメントを解除しました。", status: :see_other
    # else
    #   redirect_to question_path(question_id), alert: "許可されていないrequestです。", status: :unprocessable_entity
    # end
    unless question_answer.user_answer?(current_user)
      redirect_to question_path(question_id), alert: "許可されていないrequestです。", status: :unprocessable_entity and return
    end
    
    question_answer.destroy
    redirect_to question_path(question_id), notice: "コメントを解除しました。", status: :see_other
  end

  private
    def question_answer_params
      params.require(:question_answer).permit(:answer_content)
    end

    def question_id
      @question_id ||= params[:question_id]
    end
end

  # def edit
    # @question_answer.user_id = current_user.id
    # @question_answer.question_id = params[:question_id]
  # end

  # def update
    # @question_answer.user_id = current_user.id
    # @question_answer.question_id = params[:question_id]
    # if @question_answer.update(question_answer_params)
      # flash[:notice] = "コメントを編集しました。"
      # redirect_to("/questions/#{params[:question_id]}")
    # else
      # @question = Question.find(params[:question_id])
      # flash.now[:alert] = "コメントを入力してください。"
      # render "questions/show", status: :unprocessable_entity
    # end
  # end
