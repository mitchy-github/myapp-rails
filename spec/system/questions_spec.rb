require 'rails_helper'

RSpec.describe "Questions", type: :system do
  describe '質問投稿機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context '新規投稿した場合' do
      it "質問ができること" do
        visit new_question_path
        fill_in "question[question_title]", with: "テスト質問"
        fill_in "question[contents_question]", with: "これはテスト質問です"
        click_button "質問する"
        expect(page).to have_text("成功！")
        expect(page).to have_text("テスト質問")
        expect(page).to have_text("これはテスト質問です")
      end
    end

    context '質問に未記入の項目がある場合' do
      it 'バリデーションエラーが発生すること' do
        visit new_question_path
        fill_in "question[question_title]", with: nil
        fill_in "question[contents_question]", with: nil
        click_button "質問する"
        expect(current_path).to eq questions_path
        expect(page).to have_content "質問タイトルを入力してください"
        expect(page).to have_content "質問内容を入力してください"
      end
    end
  end

  describe 'コメント機能' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:question) { create(:question, question_title: 'テスト質問', contents_question: 'これはテスト質問です', user_id: user.id) }

    before do
      log_in_as user2
    end

    context '質問に回答した場合' do
      it "回答ができること" do
        visit question_path(question.id)
        fill_in "question_answer[answer_content]", with: 'テスト回答です'
        click_on "登録"
        expect(current_path).to eq question_path(question)
        expect(page).to have_content "コメントしました。"
      end
    end

    context '質問に空欄で回答した場合' do
      it "バリデーションエラーが発生すること" do
        visit question_path(question.id)
        click_on "登録"
        expect(current_path).to eq question_path(question)
        expect(page).to have_content "空白、1000文字以上で回答することはできません。"
      end
    end
  end

  describe '一覧表示機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
      create(:question, question_title: 'テスト質問', contents_question: 'これはテスト質問です', user: user)
    end

    context '質問を投稿した場合' do
      it "表示されること" do
        visit questions_path
        expect(page).to have_text("テスト質問")
        expect(page).to have_text("これはテスト質問です")
      end
    end
  end
end
