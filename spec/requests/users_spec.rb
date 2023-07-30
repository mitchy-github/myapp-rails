require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    let!(:user) { create(:user) }

    it 'リクエストが成功すること' do
      get signup_path
      expect(response).to have_http_status(200)
    end

    it "ログイン済みであればマイページに遷移できること" do
      log_in_as user
      get user_path(user)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users" do
    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post signup_path, params: { user: attributes_for(:user) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが登録されること' do
        expect do
          post signup_path, params: { user: attributes_for(:user) }
        end.to change(User, :count).by(1)
      end

      it 'リダイレクトすること' do
        post signup_path, params: { user: attributes_for(:user) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        post signup_path, params: { user: attributes_for(:user, :invalid) }
        expect(response).to have_http_status(422)
      end

      it 'ユーザーが登録されないこと' do
        expect do
          post signup_path, params: { user: attributes_for(:user, :invalid) }
        end.to_not change(User, :count)
      end
    end
  end

  describe 'PUT /users' do
    let!(:takashi) { create :takashi }

    before do
      log_in_as takashi
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put user_url takashi, params: { user: attributes_for(:satoshi) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザー名が更新されること' do
        expect do
          put user_url takashi, params: { user: attributes_for(:satoshi) }
        end.to change { User.find(takashi.id).name }.from('Takashi').to('Satoshi')
      end

      it 'リダイレクトすること' do
        put user_url takashi, params: { user: attributes_for(:satoshi) }
        expect(response).to redirect_to User.last
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put user_url takashi, params: { user: attributes_for(:user, :invalid) }
        expect(response).to have_http_status(422)
      end

      it 'ユーザー名が変更されないこと' do
        expect do
          put user_url takashi, params: { user: attributes_for(:user, :invalid) }
        end.to_not change(User.find(takashi.id), :name)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }

    before do
      log_in_as user
    end

    it 'リクエストが成功すること' do
      delete user_url user
      expect(response).to have_http_status(303)
    end

    it 'ユーザーが削除されること' do
      expect do
        delete user_url user
      end.to change(User, :count).by(-1)
    end

    it 'ユーザー一覧にリダイレクトすること' do
      delete user_url user
      expect(response).to redirect_to(root_url)
    end
  end
end
