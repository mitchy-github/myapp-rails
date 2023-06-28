# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "内容に問題がないかのチェック" do
    let!(:user) { create(:user) }
    let!(:email_pass) { build(:user, email: 'a' * 245 + '@sample.jp') }
    let!(:email_save) { build(:user, email: 'SAMPLE@SAMPLE.JP') }

    context '内容に問題ない場合' do
      it "正常にユーザー登録できること" do
        expect(user).to be_valid
      end
    end

    context 'emailが255文字以下の場合' do
      it 'emailに問題がないこと' do
        expect(email_pass).to be_valid
      end
    end

    context 'emailが大文字だった場合' do
      it 'emailは全て小文字で保存されること' do
        email_save.save!
        expect(email_save.reload.email).to eq 'sample@sample.jp'
      end
    end
  end

  describe "バリデーションチェック" do
    let!(:name_is_blank) { build(:user, name: '') }
    let!(:birthday_nil) { build(:user, birthday: nil) }
    let!(:sex_nil) { build(:user, sex: nil) }

    context 'nameが空の場合' do
      it "バリデーションエラーが発生すること" do
        name_is_blank.valid?
        expect(name_is_blank.errors.full_messages).to include("Nameを入力してください")
      end
    end

    context '生年月日が空の場合' do
      it "バリデーションエラーが発生すること" do
        birthday_nil.valid?
        expect(birthday_nil.errors.full_messages).to include("Birthdayを入力してください")
      end
    end

    context '性別が入力されていない場合' do
      it "バリデーションエラーが発生すること" do
        sex_nil.valid?
        expect(sex_nil.errors.full_messages).to include("Sexを入力してください")
      end
    end
  end

  describe "email関連のバリデーションチェック" do
    let!(:other_user) { create(:user) }
    let!(:another_user) { build(:user, email: user.email) }
    let!(:user) { build(:user, email: other_user.email) }
    let!(:email_is_blank) { build(:user, email: '') }
    let!(:email_length) { build(:user, email: 'a' * 246 + '@sample.jp') }

    context 'メールアドレスがすでに登録されている場合' do
      it 'バリデーションエラーが発生すること' do
        user.valid?
        expect(user.errors[:email]).to include('はすでに存在します')
      end
    end

    context '重複したemailが存在する場合' do
      it "バリデーションエラーが発生すること" do
        user.save
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Emailはすでに存在します")
      end
    end

    context 'emailが空の場合' do
      it "バリデーションエラーが発生すること" do
        email_is_blank.valid?
        expect(email_is_blank.errors.full_messages).to include("Emailを入力してください", "Emailは不正な値です")
      end
    end

    context 'emailが256文字以上の場合' do
      it 'バリデーションエラーが発生すること' do
        email_length.valid?
        expect(email_length.errors).to be_added(:email, :too_long, count: 255)
      end
    end
  end

  describe 'パスワードの検証' do
    let!(:user) { build(:user) }
    let!(:password_nil) { build(:user, password: nil) }
    let!(:password_length) { build(:user, password: "00000", password_confirmation:"00000") }
    let!(:password_confirmation_is_blank) { build(:user, password_confirmation:"") }
    let!(:password_invalid) { build(:user, password: "aaaaaa") }
    let!(:password_invalid2) { build(:user, password: "ああああああ") }
    let!(:password_not_match) { build(:user, password: 'password', password_confirmation:'pass') }

    context 'passwordが空の場合' do
      it "バリデーションエラーが発生すること" do
        password_nil.valid?
        expect(password_nil.errors.full_messages).to include("Passwordを入力してください", "Passwordは8文字以上で入力してください")
      end
    end

    context 'passwordが5文字以下の場合' do
      it "バリデーションエラーが発生すること" do
        password_length.valid?
        expect(password_length.errors.full_messages).to include("Passwordは8文字以上で入力してください")
      end
    end

    context 'passwordが存在してもpassword_confirmationが空だった場合' do
      it "バリデーションエラーが発生すること" do
        password_confirmation_is_blank.valid?
        expect(password_confirmation_is_blank.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません")
      end
    end

    context 'passwordが半角英数字混合でない場合' do
      it "バリデーションエラーが発生すること" do
        password_invalid.valid?
        expect(password_invalid.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません", "Passwordは8文字以上で入力してください")
      end
    end

    context 'passwordが全角だった場合' do
      it "バリデーションエラーが発生すること" do
        password_invalid2.valid?
        expect(password_invalid2.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません", "Passwordは8文字以上で入力してください")
      end
    end

    context 'パスワードと確認用パスワードが間違っている場合' do
      it '無効であること' do
        password_not_match.valid?
        expect(password_not_match.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
      end
    end

    context 'パスワードが暗号化されていること' do
      it 'パスワードが暗号化されていること' do
        expect(user.encrypted_attributes).to_not eq 'password'
      end
    end
  end

  describe 'フォーマットの検証' do
    let!(:user) { build(:user) }

    context 'メールアドレスが正常なフォーマットの場合' do
      it '有効であること' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          user.email = valid_address
          expect(user).to be_valid
        end
      end
    end
  end

  describe "インスタンスメソッド" do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }
    # let(:post_by_user_a) { create(:post, user:user_a) }
    # let(:post_by_user_b) { create(:post, user: user_b) }
    # let(:post_by_user_c) { create(:post, user: user_c) }

    context "フォローメソッド" do
      it 'フォローができること' do
          expect { user_a.follow(user_b.id) }.to change { Relationship.count }.by(1)
      end

      it 'フォローが解除できること' do
          user_a.follow(user_b.id)
          expect { user_a.unfollow(user_b.id) }.to change { Relationship.count }.by(-1)
      end

      it 'フォローしている場合 true' do
          user_a.follow(user_b.id)
          expect(user_a.following?(user_b)).to eq true
      end

      it 'フォローしていない場合 false' do
          expect(user_a.following?(user_c)).to eq false
      end
    end
  end

  describe 'フォローの検証' do
    let(:tester_1) { create(:user) }
    let(:tester_2) { create(:user) }

    it'ユーザーが他のユーザーをフォロー、フォロー解除可能であること' do
      tester_1.follow(tester_2.id)
      expect(tester_1.following?(tester_2)).to eq true
      tester_1.unfollow(tester_2.id)
      expect(tester_1.following?(tester_2)).to eq false
    end

    it 'フォロー中のユーザーが削除されると、フォローが解消されること' do
      tester_1.follow(tester_2.id)
      expect(tester_1.following?(tester_2)).to eq true
      tester_1.destroy
      expect(tester_1.following?(tester_2)).to eq false
    end
  end
end
