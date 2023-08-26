module CategoryMethods
  extend ActiveSupport::Concern

  def extract_category(contents_question)
    if contents_question.blank?
      return
    end
      return contents_question.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
  end

  def save_category(category_array, question_instance)
    if category_array.blank?
      return
    end
      category_array.uniq.map do |category|
      cate = Category.find_or_create_by(category: category.downcase.delete('#'))

      category_question = CategoryQuestion.new
      category_question.question_id = question_instance.id
      category_question.category_id = cate.id
      category_question.save!
    end
  end

  def creating_structures(questions: "", category_questions: "", categories: "")
    array = []
    questions.each do |question|
      category = []
        question_cate = question.attributes
        related_category_records = category_questions.select{ |cq| cq.question_id == question.id }
        related_category_records.each do |record|
          category << categories.detect{ |category| category.id == record.category_id }
        end
        question_cate["categories"] = category
        array << question_cate
    end
      return array
  end

  def delete_records_related_to_category(question_id)
    relationship_records = CategoryQuestion.where(question_id: question_id)
    if relationship_records.present?
      relationship_records.each do |record|
          record.destroy
      end
    end
      all_categories = Category.all
      all_related_records = CategoryQuestion.all
      all_categories.each do |category|
        if all_related_records.none?{ |record| category.id == record.category_id }
          category.destroy
        end
      end
  end
end
