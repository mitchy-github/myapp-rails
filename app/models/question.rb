class Question < ApplicationRecord
  has_many :question_answers
  
  has_many :category_questions
  has_many :categories, through: :category_questions

  belongs_to :user

  validates :question_title, presence: true, length: { maximum: 100 }
  validates :contents_question, presence: true, length: { maximum: 1000 }
end
