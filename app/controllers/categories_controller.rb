class CategoriesController < ApplicationController
  include CategoryMethods

  def index
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
  end

  def show
    category_questions = CategoryQuestion.all
    relationship_records = category_questions.select{ |cq| cq.category_id == params[:id].to_i}.map(&:question_id) #中間テーブルの全レコードより、該当ハッシュタグIDが含まれるものを取得→post_idを配列に格納 #=> [1,3]
    all_questions = Question.all
    @questions = all_questions.select{ |question| relationship_records.include?(question.id)} #中間テーブルの情報が含まれるPostのレコードを取得する
    @question_objects = creating_structures(questions: @questions,category_questions: category_questions ,categories: Category.all) #取得したレコードをハッシュに変換し、ハッシュタグを一つ一つのハッシュに格納する。
  end
end
