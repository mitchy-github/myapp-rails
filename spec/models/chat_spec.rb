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
require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let!(:chat) {build(:chat, user_id: user_b.id)}
  subject {test_message.valid?}
  let(:test_message) {chat}

  context 'messageカラムが空欄の場合' do
    it 'バリデーションエラーが発生すること' do
      user_a.follow(user_b.id)
      user_b.follow(user_a.id)
      test_message.message = ''
      is_expected.to eq false;
    end
  end

  context 'messageカラムが140文字以上の場合' do
    it 'バリデーションエラーが発生すること' do
      user_a.follow(user_b.id)
      user_b.follow(user_a.id)
      test_message.message = 'a' * 150
      is_expected.to eq false;
    end
  end
end
