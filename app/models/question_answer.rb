# == Schema Information
#
# Table name: question_answers
#
#  id             :bigint           not null, primary key
#  answer_content :text(65535)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  question_id    :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_question_answers_on_question_id  (question_id)
#  index_question_answers_on_user_id      (user_id)
#
class QuestionAnswer < ApplicationRecord
  has_many :likes
  
  belongs_to :user
  belongs_to :question

  validates :answer_content, presence: true, length: { maximum: 1000 }

  def user_answer?(user)
    user.id == user_id
  end

end
