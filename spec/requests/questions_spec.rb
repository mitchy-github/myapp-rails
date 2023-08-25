require 'rails_helper'

RSpec.describe "Questions", type: :request do
  describe "GET /questions" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user_id: user.id) }

    before do
      log_in_as user
    end

    it "URLのリクエストが通ること" do
      get new_question_path
      expect(response).to have_http_status(200)
    end

    it "URLのリクエストが通ること" do
      get questions_path
      expect(response).to have_http_status(200)
    end

    it "URLのリクエストが通ること" do
      get question_path(question)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /questions" do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post questions_path, params: { question: attributes_for(:question) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが登録されること' do
        expect do
          post questions_path, params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'リダイレクトすること' do
        post questions_path, params: { question: attributes_for(:question) }
        expect(response).to redirect_to Question
      end
    end
  end

  describe 'PUT /questions' do
    let!(:takashiq) { create :takashi }
    let!(:question) { create(:takashiq, user_id: takashiq.id) }

    before do
      log_in_as takashiq
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put question_url question, params: { question: attributes_for(:satoshiq) }
        expect(response).to have_http_status(302)
      end

      it 'タイトルが更新されること' do
        expect do
          put question_url question, params: { question: attributes_for(:satoshiq) }
        end.to change { Question.find(question.id).question_title }.from('Takashiq').to('Satoshiq')
      end

      it 'リダイレクトすること' do
        put question_url question, params: { question: attributes_for(:satoshiq) }
        expect(response).to redirect_to Question.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put question_url question, params: { question: attributes_for(:question, :invalid) }
        expect(response).to have_http_status(422)
      end

      it 'タイトルが変更されないこと' do
        expect do
          put question_url question, params: { question: attributes_for(:question, :invalid) }
        end.to_not change(Question.find(question.id), :question_title)
      end
    end
  end

  describe 'DELETE /posts' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user_id: user.id) }

    it '投稿が削除される' do
      log_in_as user
      expect do
        delete question_path(question)
      end.to change(Question, :count).by(-1)
    end
  end
end

# 取りやめたテスト１
# describe 'DELETE /destroy' do
#   # 以降はFactory_Botで設定済みと仮定
#   # UserモデルとPostモデルの関連付けも設定済みと仮定
#   let!(:user) { create(:user) } # テストユーザーを生成
#   let!(:question) { create(:question, user_id: user.id) } # userの投稿データを作成

#   # before do
#   #   log_in_as user
#   #   delete question_path(question) # 投稿データを削除するリクエストを送る
#   # end

#   it '投稿が削除される' do
#     log_in_as user
#     delete question_path(question)
#     expect(user.questions.reload).not_to include question #左記のように記載すると失敗する
#   end
# end

# 取りやめたテスト２

  # describe "POST /questions" do
  #   let!(:user) { create(:user) }

  #   it '投稿できること' do
  #     log_in_as user
  #     post questions_path, params: { question: { question_title: 'テストタイトル', contents_question: 'テスト投稿です' } }
  #     expect(response).to have_http_status(302)
  #   end

  #   # it '削除できるか' do
  #   #   log_in_as user
  #   #   delete question_path(user.questions)
  #   #   expect(user.posts.reload).not_to include user
  #   # end
  # end
