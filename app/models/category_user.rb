# == Schema Information
#
# Table name: category_users
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_category_users_on_category_id  (category_id)
#  index_category_users_on_user_id      (user_id)
#
class CategoryUser < ApplicationRecord
  belongs_to :user
  belongs_to :category, dependent: :destroy
end
