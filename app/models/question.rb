class Question < ApplicationRecord
  has_many :question_answers
  
  has_many :category_questions
  has_many :categories, through: :category_questions

  belongs_to :user
end
