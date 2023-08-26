class CategoriesController < ApplicationController
  include CategoryMethods

  def index
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

  def show
    category_questions = CategoryQuestion.all
    relationship_records = category_questions.select{ |cq| cq.category_id == params[:id].to_i }.map(&:question_id)
    all_questions = Question.all
    @questions = all_questions.select{ |question| relationship_records.include?(question.id) }
  end
end
