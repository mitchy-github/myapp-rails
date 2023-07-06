require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザーの新規登録" do

    context 'ユーザーの新規作成ページに遷移した場合' do
      it '問題なくページが表示されること' do
        visit root_path
        click_on '新規登録', match: :first
        expect(page).to have_content 'ユーザー登録'
      end
    end

    context 'ユーザーの新規作成ページに遷移した場合' do
      it '問題なく遷移ができていること' do
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
          expect(page).to have_content '新規登録完了しました。'
      end
    end
  end

  describe "フォロー関係" do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
        log_in_as user1
    end

    it 'フォローができること' do
      visit user_path(user2.id)

      expect(page).to have_content 'フォローする'
      expect {
      #     # within "#follow-area-#{user2.id}" do
      #         # click_on 'フォローする'
      #         # save_and_open_page
      #         # expect(page).to have_content 'これでできたら不思議'
      #         # save_and_open_page
      #         # end
      # # }.to change { user1.follower.count }.by(1)
        # within ('.user_relationship_follow') do
          # find(:link, "フォローする").click
          click_link 'フォローする'
          expect(page).to have_content 'フォロー外す'
          # user1.follow(user2.id)
        # end
      }.to change { user1.follower.count }.by(1)
    end

    # it 'フォローができること' do
    #     visit users_path
    #     visit user_path(user2.id)
    #     click_on "フォローする"
    #     save_and_open_page
    #     expect(page).to have_content 'フォロー外す'
    #     # binding.pry
    #     # expect(user2.followed.count).to eq(1)
    #     expect(user1.follower.count).to eq(1)
    # end

    it 'フォローが解除できること'  do
        visit users_path
        expect {
                click_link followers_user_path(user2.id)
                expect(page).to have_content 'フォローする'
        }.to change { login.following }.by(-1)
    end
  end
end
