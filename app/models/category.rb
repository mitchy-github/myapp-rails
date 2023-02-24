class Category < ApplicationRecord
  has_many :category_users
  has_many :users, through: :category_users

  has_many :category_questions
  has_many :questions, through: :category_questions

  validates :category, presence: true
end
