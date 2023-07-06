# == Schema Information
#
# Table name: communities
#
#  id                           :bigint           not null, primary key
#  community_explanation_column :text(65535)      not null
#  community_image              :string(255)
#  community_name               :string(255)      not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
class Community < ApplicationRecord
  has_many :community_users, dependent: :destroy
  has_many :users, through: :community_users

  validates :community_name, presence: true, length: { maximum: 100 }
  validates :community_explanation_column, presence: true, length: { maximum: 800 }
end
