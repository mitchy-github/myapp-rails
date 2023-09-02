require 'rails_helper'

RSpec.describe "Posts", js: true, type: :system do
  describe '投稿機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
    end

    context '新規投稿した場合' do
      it "投稿ができること" do
        visit new_post_path
        fill_in "post[post_title]", with: "テスト投稿"
        fill_in "post[post_content]", with: "これはテスト投稿です"
        click_button "投稿する"
        expect(page).to have_content "投稿しました"
        expect(page).to have_content "テスト投稿"
      end
    end

    context '2MBを超えている画像を投稿した場合' do
      it "バリデーションエラーが発生すること" do
        visit new_post_path
        attach_file "ファイルを選択", "#{Rails.root}/spec/fixtures/files/fixture_2.6m.jpg", make_visible: true
        expect(page).to have_content "ファイルサイズの上限(1枚あたり2MB)を超えている画像はアップロードできません。"
      end
    end

    context '投稿に未記入の項目がある場合' do
      it 'バリデーションエラーが発生すること' do
        visit new_post_path
        fill_in "post[post_title]", with: nil
        fill_in "post[post_content]", with: nil
        click_button "投稿する"
        expect(current_path).to eq posts_path
        expect(page).to have_content "タイトルを入力してください"
        expect(page).to have_content "投稿内容を入力してください"
      end
    end
  end

  describe "フォロー関係" do
    let!(:user1) {create(:user)}
    let!(:user2) {create(:user)}
    let!(:post2) { create(:post, user: user2) }

    before do
      log_in_as user1
    end

    it 'いいねができること' do
      visit post_path(post2.id)
      expect(page).to have_content 'いいね'
      expect {
        click_on 'いいね'
      }.to change { user1.favorites.count }.by(1)
    end

    it 'いいねが解除できること'do
        visit post_path(post2.id)
        click_on 'いいね'
        expect {
            click_on 'いいね'
        }.to change { user1.favorites.count }.by(-1)
    end
  end

  describe '一覧表示機能' do
    let!(:user) { create(:user) }

    before do
      log_in_as user
      create(:post, post_title: 'テスト投稿', post_content: 'これはテスト投稿です', user: user)
    end

    context '投稿した場合' do
      it "表示されること" do
        visit posts_path
        expect(page).to have_text("テスト投稿")
      end
    end
  end
end
