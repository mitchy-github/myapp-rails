require 'rails_helper'

RSpec.describe "Posts", type: :system do
  describe '投稿機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context 'ログインユーザーが新規投稿した場合' do
      it "問題なく投稿ができること" do
        visit new_post_path

        fill_in "post[post_title]", with: "テスト投稿"
        fill_in "post[post_content]", with: "これはテスト投稿です"
        click_button "投稿する"

        expect(page).to have_text("投稿しました")
        expect(page).to have_text("テスト投稿")
      end
    end
  end


  describe '一覧表示機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
      create(:post, post_title: 'テスト投稿', post_content: 'これはテスト投稿です', user: user)
    end

    context '投稿した場合' do
      it "問題なく表示されること" do
        visit posts_path

        expect(page).to have_text("テスト投稿")
      end
    end
  end
end
