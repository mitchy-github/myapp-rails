require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    let!(:user) { create(:user) }
    let!(:postn) { create(:post, user_id: user.id) }

    before do
      log_in_as user
    end

    it "URLのリクエストが通ること" do
      get new_post_path
      expect(response).to have_http_status(200)
    end

    it "URLのリクエストが通ること" do
      get posts_path
      expect(response).to have_http_status(200)
    end

    it "URLのリクエストが通ること" do
      get post_path(postn)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /posts" do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        post posts_path, params: { post: attributes_for(:post) }
        expect(response).to have_http_status(302)
      end

      it 'ユーザーが登録されること' do
        expect do
          post posts_path, params: { post: attributes_for(:post) }
        end.to change(Post, :count).by(1)
      end

      it 'リダイレクトすること' do
        post posts_path, params: { post: attributes_for(:post) }
        expect(response).to redirect_to Post
      end
    end
  end

  describe 'PUT /posts' do
    let!(:takaship) { create :takashi }
    let!(:postn) { create(:takaship, user_id: takaship.id) }

    before do
      log_in_as takaship
    end

    context 'パラメータが妥当な場合' do
      it 'リクエストが成功すること' do
        put post_url postn, params: { post: attributes_for(:satoship) }
        expect(response).to have_http_status(302)
      end

      it 'タイトルが更新されること' do
        expect do
          put post_url postn, params: { post: attributes_for(:satoship) }
        end.to change { Post.find(postn.id).post_title }.from('Takaship').to('Satoship')
      end

      it 'リダイレクトすること' do
        put post_url postn, params: { post: attributes_for(:satoship) }
        expect(response).to redirect_to Post
      end
    end

    context 'パラメータが不正な場合' do
      it 'リクエストが成功すること' do
        put post_url postn, params: { post: attributes_for(:post, :invalid) }
        expect(response).to have_http_status(422)
      end

      it 'タイトルが変更されないこと' do
        expect do
          put post_url postn, params: { post: attributes_for(:post, :invalid) }
        end.to_not change(Post.find(postn.id), :post_title)
      end
    end
  end

  describe 'DELETE /posts' do
    let!(:user) { create(:user) }
    let!(:postn) { create(:post, user_id: user.id) }

    it '投稿が削除される' do
      log_in_as user
      expect do
        delete post_path(postn)
      end.to change(Post, :count).by(-1)
    end
  end
end
