# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  contents_question :text(65535)      not null
#  question_title    :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  best_answer_id    :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Question, type: :model do
  describe '内容に問題がないかのチェック' do
    let!(:user) { create(:user) }
    let!(:question) { build(:question, user_id: user.id) }

    context '内容に問題がない場合' do
      it '表示されること' do
        expect(question).to be_valid
      end
    end
  end

  describe 'バリデーションチェック' do
    let!(:user) { create(:user) }
    let!(:question) { build(:question, user_id: user.id) }
    let!(:title_is_blank) { build(:question, user_id: user.id, question_title: '') }
    let!(:title_length) { build(:question, user_id: user.id, question_title: 'a' * 110) }
    let!(:contents_is_blank) { build(:question, user_id: user.id, contents_question: '') }
    let!(:contents_length) { build(:question, user_id: user.id, contents_question: 'a' * 1010) }

    context 'titleカラムが空欄でない場合' do
      it 'バリデーションエラーが発生すること' do
        title_is_blank.valid?
        expect(title_is_blank.errors.full_messages).to eq ["質問タイトルを入力してください"]
      end
    end

    context 'question_titleカラムが100文字以上の場合' do
      it 'バリデーションエラーが発生すること' do
        title_length.valid?
        expect(title_length.errors.full_messages).to eq ["質問タイトルは100文字以内で入力してください"]
      end
    end

    context 'contentカラムが空欄の場合' do
      it 'バリデーションエラーが発生すること' do
        contents_is_blank.valid?
        expect(contents_is_blank.errors.full_messages).to eq ["質問内容を入力してください"]
      end
    end

    context 'contents_questionカラムが1000文字以上の場合' do
      it 'バリデーションエラーが発生すること' do
        contents_length.valid?
        expect(contents_length.errors.full_messages).to eq ["質問内容は1000文字以内で入力してください"]
      end
    end
  end
end
