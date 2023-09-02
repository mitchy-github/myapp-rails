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
