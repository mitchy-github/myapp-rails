# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  post_content :text(4294967295) not null
#  post_title   :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
class Post < ApplicationRecord
  belongs_to :user

  validates :post_title, presence: true, length: { maximum: 100 }
  validates :post_content, presence: true
end
