require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリデーションチェック' do
    let(:user) {create(:user)}
    let!(:question) {build(:question, user_id: user.id)}
    subject {test_question.valid?}
    let(:test_question) {question}

    context 'titleカラムが空欄でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_question.question_title = ''
        is_expected.to eq false;
      end
    end

    context 'question_titleカラムが100文字以上でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_question.question_title = 'a' * 110
        is_expected.to eq false;
      end
    end

    context 'contentカラムが空欄でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_question.contents_question = ''
        is_expected.to eq false;
      end
    end

    context 'contents_questionカラムが1000文字以上でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_question.contents_question = 'a' * 1010
        is_expected.to eq false;
      end
    end
  end
end
