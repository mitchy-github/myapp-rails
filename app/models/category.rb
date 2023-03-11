# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  category   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :category_users
  has_many :users, through: :category_users

  has_many :category_questions
  has_many :questions, through: :category_questions

  validates :category, presence: true
end
