# == Schema Information
#
# Table name: chats
#
#  id         :bigint           not null, primary key
#  message    :text(65535)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint
#  user_id    :bigint
#
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room#データ残っている

  validates :message, presence: true, length: { maximum: 140 }
end
