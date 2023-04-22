class QuestionsController < ApplicationController
  include CategoryMethods
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only:[:new, :edit, :update, :destroy]

  def index
    @test = "テストテキスト"
    # @questions = current_user.questions.all
    @questions = Question.all
    @categories = Category.all
    @category_questions = CategoryQuestion.all
    @question_objects = creating_structures(questions: @questions,category_questions: @category_questions,categories: @categories)
  end

  def show
    @question_answer = QuestionAnswer.new
    @question = Question.find(params[:id])
    related_records = CategoryQuestion.where(question_id: @question.id).pluck(:category_id) #=> [1,2,3] idのみを配列にして返す
    categories = Category.all
    @categories = categories.select{|category| related_records.include?(category.id)} #hashtagテーブルより中間テーブルで取得したidのハッシュタグを取得。配列に。
    @display_contents_question = @question.contents_question.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/,"") #実際に表示するキャプション。ハッシュタグが文字列のまま表示されてしまうので、#から始まる文字列を""に変換したものをViewにて表示
  end

  def new
    @categories = Category.all
    @question = Question.new
  end

  def create
    # @question = Question.new(question_params)
    # @question.user_id = current_user.id
    # @categories = Category.all
    # @question.save!
    #   flash[:notice] = "成功！"
    #   redirect_to("/questions/new")
    # rescue StandardError
    #   flash.now[:alert] = "失敗！"
    #   render "questions/new", status: :unprocessable_entity

    @question = Question.new(question_params) #インスタンスの作成
    @question.user_id = current_user.id
    category = extract_category(@question.contents_question) #パラメーターのcaptionの中よりハッシュタグを抽出
    @question.save! #一度投稿を保存
      save_category(category,@question) #先ほど抽出したハッシュタグをハッシュタグテーブルへ、作成したpostのidとハッシュタグのidを中間テーブルへ保存
      flash[:notice] = "成功！"
      redirect_to questions_path

    rescue StandardError
      # flash.now[:alert] = "失敗！"
        render "questions/new", status: :unprocessable_entity
      # render new_question_path, status: :unprocessable_entity
  end

  def edit
    @categories = Category.all
    @question = Question.find(params[:id])
  end

  def update
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

    unless logged_in? && @question.user_question?(current_user) && @question.update(question_params)
      render "questions/edit", status: :unprocessable_entity and return
    end

    @question = Question.find(params[:id])
    strong_paramater = question_params
    delete_records_related_to_category(params[:id]) #こちらのメソッドで中間テーブルとハッシュタグのレコードを削除

    # @question.update(question_params)
    flash[:notice] = "投稿内容を編集しました"
    category = extract_category(@question.contents_question) #投稿よりハッシュタグを取得
    save_category(category,@question) #ハッシュタグの保存
    redirect_to question_path(@question.id)
  end

  def destroy
    # @question.destroy
    # flash[:notice] = "成功！"
    # redirect_to "/questions", status: :see_other

    @question = Question.find_by(id: params[:id]) #削除対象のレコード
    @question.destroy #投稿を削除
    delete_records_related_to_category(params[:id]) #中間テーブルとハッシュタグのレコードを削除
    flash[:notice] = "投稿を削除しました"
    redirect_to questions_path, status: :see_other
  end

private
  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:question_title, :contents_question, :best_answer_id)
      # , {:category_ids => []})
  end
end
