require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'GET #new' do
    it 'リクエストが成功すること' do
      get signup_path
      expect(response.status).to eq 200
    end
  end
end
