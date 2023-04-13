# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  contents_question :text(65535)      not null
#  question_title    :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  best_answer_id    :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
class Question < ApplicationRecord
  has_many :question_answers, dependent: :destroy

  has_many :category_questions
  has_many :categories, through: :category_questions

  belongs_to :user

  validates :question_title, presence: true, length: { maximum: 100 }
  validates :contents_question, presence: true, length: { maximum: 1000 }

  def user_question?(user)
    user.id == user_id
  end
end
