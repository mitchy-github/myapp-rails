require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /sessions" do
    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(200)
#      puts response.bo
    end
  end

  describe "POST,delete /sessions" do
    let!(:user) { create(:user) }
    # before do
    #     log_in_as user
    # end
    it '会員登録済みならログインできる' do
      post login_path, params: { session: { email: user.email, password: user.password } }
      expect(response).to have_http_status(302)
      # user
      # get login_path
      # binding.pry
      # post '/login', params: { session: { user: user } }
      # session_params = { session: { email: user.email, password: user.password } }
      # post "/login", params: session_params
      # post '/login', params: { session: FactoryBot.attributes_for(:user) }
      # post '/login', params: { session: { email: user.email, password: user.password } }
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
end
