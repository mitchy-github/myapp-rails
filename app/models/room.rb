# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  has_many :user_rooms, dependent: :destroy#データ残っている
  has_many :chats, dependent: :destroy
end
