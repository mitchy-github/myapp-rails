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
  describe '内容に問題がないかのチェック' do
    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }
    let!(:chat) { build(:chat, user_id: user_b.id) }
    # subject {test_message.valid?}
    # let!(:test_message) {chat}

    context '内容に問題がない場合' do
      it '表示されること' do
        user_a.follow(user_b.id)
        user_b.follow(user_a.id)
        expect(chat).to be_valid
      end
    end
  end

  describe 'バリデーションチェック' do
    let!(:user_a) { create(:user) }
    let!(:user_b) { create(:user) }
    let!(:chat) { build(:chat, user_id: user_b.id) }
    let!(:chat_is_blank) { build(:chat, user_id: user_b.id, message: "") }
    let!(:chat_length) { build(:chat, user_id: user_b.id, message: "a" * 150) }
    # subject {test_message.valid?}
    # let!(:test_message) {chat}

    context 'メッセージを送信した場合' do
      it '送信できること' do
        user_a.follow(user_b.id)
        user_b.follow(user_a.id)
        expect(chat).to be_valid
      end
    end

    context 'messageカラムが空欄の場合' do
      it 'バリデーションエラーが発生すること' do
        user_a.follow(user_b.id)
        user_b.follow(user_a.id)
        chat_is_blank.valid?
        expect(chat_is_blank.errors.full_messages).to eq ["メッセージを入力してください"]
      end
    end

    context 'messageカラムが140文字以上の場合' do
      it 'バリデーションエラーが発生すること' do
        user_a.follow(user_b.id)
        user_b.follow(user_a.id)
        chat_length.valid?
        expect(chat_length.errors.full_messages).to eq ["メッセージは140文字以内で入力してください"]
        # test_message.message = 'a' * 150
        # is_expected.to eq false;
      end
    end
  end
end
