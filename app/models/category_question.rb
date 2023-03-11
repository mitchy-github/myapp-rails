# == Schema Information
#
# Table name: category_questions
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  question_id :bigint           not null
#
# Indexes
#
#  index_category_questions_on_category_id  (category_id)
#  index_category_questions_on_question_id  (question_id)
#
class CategoryQuestion < ApplicationRecord
  belongs_to :question
  belongs_to :category
end
