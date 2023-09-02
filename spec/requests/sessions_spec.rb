require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions" do
    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST,delete /sessions" do
    let!(:user) { create(:user) }
    it '会員登録済みならログインできる' do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response).to have_http_status(302)
    end

    it 'ログアウトできるか' do
      delete '/logout'
      expect(response).to have_http_status(302)
    end
  end
end
