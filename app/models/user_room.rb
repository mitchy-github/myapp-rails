# == Schema Information
#
# Table name: user_rooms
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint
#  user_id    :bigint
#
class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room#データ残っている
end
