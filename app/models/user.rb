class User < ApplicationRecord
  # has_secure_password
  has_many :posts
  has_many :questions
  has_many :question_answers
  has_many :likes

  has_many :community_users
  has_many :communities, through: :community_users

  has_many :category_users
  has_many :categories, through: :category_users

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :sex, presence: true
  validates :birthday, presence: true
  validates :region, presence: true
  validates :password_digest, presence: true
end
