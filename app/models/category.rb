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
  has_many :category_users, dependent: :destroy
  has_many :users, through: :category_users

  has_many :category_questions, dependent: :destroy
  has_many :questions, through: :category_questions

  validates :category, presence: true, uniqueness: { case_sensitive: false }

  def user_category?(question)
    question["user_id"] == current_user["id"]
  end
end
