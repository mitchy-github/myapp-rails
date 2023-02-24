class QuestionAnswer < ApplicationRecord
  has_many :likes
  
  belongs_to :user
  belongs_to :question

  validates :answer_content, presence: true, length: { maximum: 1000 }
end
