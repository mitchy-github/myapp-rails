require 'rails_helper'

RSpec.describe "Questions", type: :system do
  describe '質問投稿機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context 'ログインユーザーが新規投稿した場合' do
      it "問題なく質問ができること" do
        visit new_question_path

        fill_in "question[question_title]", with: "テスト質問"
        fill_in "question[contents_question]", with: "これはテスト質問です"
        click_button "質問する"

        expect(page).to have_text("成功！")
        expect(page).to have_text("テスト質問")
        expect(page).to have_text("これはテスト質問です")
      end
    end
  end


  describe '一覧表示機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
      create(:question, question_title: 'テスト質問', contents_question: 'これはテスト質問です', user: user)
    end

    context '質問を作成した場合' do
      it "問題なく表示されること" do
        visit questions_path

        expect(page).to have_text("テスト質問")
        expect(page).to have_text("これはテスト質問です")
      end
    end
  end
end
