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
FactoryBot.define do
  factory :chat do
    message { Faker::Hacker.say_something_smart }
    user
  end
end
