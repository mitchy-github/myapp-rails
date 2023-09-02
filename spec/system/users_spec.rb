require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザーの新規登録" do
    context 'ユーザーの新規作成ページに遷移した場合' do
      it 'ページが表示されること' do
        visit root_path
        click_on '新規登録', match: :first
        expect(page).to have_content 'ユーザー登録'
      end
    end

    context 'ユーザーの新規作成ページに遷移した場合' do
      it '遷移ができていること' do
        visit signup_path
        expect(page).to have_content '新規登録'
        expect(current_path).to eq signup_path
      end
    end

    context '必須項目が全て入力されている場合' do
      it '登録が成功すること' do
        visit signup_path
        fill_in 'user[name]', with: 'fugafuga'
        fill_in 'user[email]', with: 'rails@example.com'
        fill_in 'user[password]', with: '12345678'
        fill_in 'user[password_confirmation]', with: '12345678'
        choose '男'
        fill_in 'user[birthday]', with: '002020-06-01-10:30'
        select '東京都', from: 'user[region]'
        click_button '登録'
        expect(current_path).to eq user_path(User.last)
        expect(page).to have_content '新規登録完了しました'
      end
    end
  end

  describe "ユーザーの新規登録" do
    context '未記入の項目がある場合' do
      it 'ユーザーの新規作成が失敗すること' do
        visit signup_path
        fill_in 'user[name]', with: 'fugafuga'
        fill_in 'user[email]', with: nil
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        choose '男'
        fill_in 'user[birthday]', with: '002020-06-01-10:30'
        select '東京都', from: 'user[region]'
        click_button '登録'
        expect(current_path).to eq signup_path
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "メールアドレスは不正な値です"
      end
    end
  end

  describe "フォロー関係", js: true do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
        log_in_as user1
    end

    it 'フォローができること' do
      visit user_path(user2.id)
      expect(page).to have_content 'フォローする'
      expect {
        click_on 'フォローする'
      }.to change { user1.follower.count }.by(1)
    end

    it 'フォローが解除できること'do
        visit user_path(user2.id)
        click_on 'フォローする'
        expect {
            click_on 'フォロー外す'
        }.to change { user1.follower.count }.by(-1)
        expect(page).to have_content 'フォローする'
    end
  end
end
