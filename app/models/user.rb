class User < ApplicationRecord
  has_many :posts
  has_many :questions
  has_many :question_answers
  has_many :likes

  has_many :community_users
  has_many :communities, through: :community_users

  has_many :category_users
  has_many :categories, through: :category_users
end
