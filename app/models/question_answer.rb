class QuestionAnswer < ApplicationRecord
  has_many :likes
  
  belongs_to :user
  belongs_to :question
end
