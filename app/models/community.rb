class Community < ApplicationRecord
  has_many :community_users
  has_many :users, through: :community_users

  validates :community_name, presence: true, length: { maximum: 100 }
  validates :community_explanation_column, presence: true, length: { maximum: 800 }
end
