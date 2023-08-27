require "rails_helper"

RSpec.describe "Chats", js: true, type: :system do
  describe 'チャット機能' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      log_in_as user1
      visit user_path(user2.id)
      click_on 'フォローする'
    end

    context 'メッセージを送信した場合' do
      it "メッセージが送信できること" do
        log_in_as user2
        visit user_path(user1.id)
        click_on "フォローする"
        click_on "chatを始める"
        expect(page).to have_content "さんとのチャット"
        fill_in "chat[message]", with: "テストメッセージを送信しました"
        click_button "送信"
        expect(page).to have_content "テストメッセージを送信しました"
      end
    end

    context "140文字以上でメッセージを送信した場合" do
      it"バリデーションエラーが発生すること"do
        log_in_as user2
        visit user_path(user1.id)
        click_on "フォローする"
        click_on "chatを始める"
        expect(page).to have_content "さんとのチャット"
        fill_in "chat[message]", with: 'a' * 150
        click_button "送信"
        expect(page).to have_content "メッセージは140文字以内で入力してください"
      end
    end

    context "空白でメッセージを送信した場合" do
      it"バリデーションエラーが発生すること"do
        log_in_as user2
        visit user_path(user1.id)
        click_on "フォローする"
        click_on "chatを始める"
        expect(page).to have_content "さんとのチャット"
        fill_in "chat[message]", with: nil
        click_button "送信"
        expect(page).to have_content "メッセージを入力してください"
      end
    end
  end
end
