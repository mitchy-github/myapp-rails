require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions/new" do
    let!(:user) { create(:user, password: '12345678') }
    # let!(:user) { create(:user, email: user.email, password: user.password ) }

    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(200)
#      puts response.bo
    end

    it '会員登録済みならログインできる' do
      # user
      # get login_path
      # binding.pry
      # post '/login', params: { session: { user: user } }
      # , params: { session: { email: user.email, password: user.password } }
      # post login_path, params: { email: user.email, password: user.password }
      # session_params = { session: { email: user.email, password: user.password } }
      post login_path, { session: { email: user.email, password: user.password } }
      # post "/login", params: session_params
      # post '/login', params: { session: FactoryBot.attributes_for(:user) }
      expect(response).to have_http_status(200)
    end

    # it "logs in a user with valid credentials" do
    #   post "/login", params: { email: user.email, password: user.password }

    #   expect(response).to have_http_status(200)
    #   expect(session[:user_id]).to eq(user.id)
    # end

    it 'ログアウトできるか' do
      delete '/logout'
      expect(response).to have_http_status(302)
    end
  end

  describe "会員登録" do
    it '会員登録ページを表示できる' do
      get signup_path
      expect(response).to have_http_status(200)
    end
  end
end
