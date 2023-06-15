# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  describe "バリデーション 異常系" do

    it '登録できないこと' do
        user = User.new
        expect(user.save).to be_falsey
    end

    it 'メールアドレスの一意性' do
        user = create(:user)
        other_user = build(:user, email: user.email)
        other_user.valid?
        expect(other_user.errors[:email]).to include('はすでに存在します')
    end
  end

    describe "インスタンスメソッド" do
      let(:user_a) { create(:user) }
      let(:user_b) { create(:user) }
      let(:user_c) { create(:user) }
      # let(:post_by_user_a) { create(:post, user:user_a) }
      # let(:post_by_user_b) { create(:post, user: user_b) }
      # let(:post_by_user_c) { create(:post, user: user_c) }

      context "フォロメソッド" do
          it 'フォローができること' do
              expect { user_a.follow(user_b) }.to change { Relationship.count }.by(1)
          end

          it 'フォローが解除できること' do
              user_a.follow(user_b)
              expect { user_a.unfollow(user_b) }.to change { Relationship.count }.by(-1)
          end

          it 'フォローしている場合 true' do
              user_a.follow(user_b)
              expect(user_a.following?(user_b)).to eq true
          end

          it 'フォローしていない場合 false' do
              expect(user_a.following?(user_c)).to eq false
          end
      end

      # context "feedでフォロー中のuserと自分の投稿を表示する" do
      #     it 'user_aとuser_bのpostが表示される' do
      #         user_a.follow(user_b)

      #     end
      # end

      # describe 'feedの確認' do
      #     before do
      #         user_a.follow(user_b)
      #     end
      #     subject { user_a.feed }
      #     it { is_expected.to include post_by_user_a }
      #     it { is_expected.to include post_by_user_b }
      #     it { is_expected.not_to include post_by_user_c }
      # end
    end

    before do
      @user = FactoryBot.build(:user)
    end

    describe 'ユーザー新規登録' do
      context '新規登録がうまくいくとき' do
        it "内容に問題ない場合" do
          expect(@user).to be_valid
        end
        it 'emailが255文字以下のユーザーが作成可能' do
          @user.email = 'a' * 245 + '@sample.jp'
          expect(@user).to be_valid
        end
        it 'emailは全て小文字で保存される' do
          @user.email = 'SAMPLE@SAMPLE.JP'
          @user.save!
          expect(@user.reload.email).to eq 'sample@sample.jp'
        end
      end

      context '新規登録がうまくいかないとき' do
        it "nameが空だと登録できない" do
          @user.name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Nameを入力してください")
        end
        it "emailが空では登録できない" do
          @user.email = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Emailを入力してください", "Emailは不正な値です")
        end
        it "重複したemailが存在する場合登録できない" do
          @user.save
          another_user = FactoryBot.build(:user)
          another_user.email = @user.email
          another_user.valid?
          expect(another_user.errors.full_messages).to include("Emailはすでに存在します")
        end
        it 'emailが256文字以上のユーザーを許可しない' do
          @user.email = 'a' * 246 + '@sample.jp'
          @user.valid?
          expect(@user.errors).to be_added(:email, :too_long, count: 255)
        end
        it "passwordが空では登録できない" do
          @user.password = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Passwordを入力してください")
        end
        it "passwordが5文字以下であれば登録できない" do
          @user.password = "00000"
          @user.password_confirmation = "00000"
          @user.valid?
          expect(@user.errors.full_messages).to include("Passwordは8文字以上で入力してください")
        end
        it "passwordが存在してもpassword_confirmationが空では登録できない" do
          @user.password_confirmation = ""
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません")
        end
        it "passwordが半角英数字混合でなければ登録できない" do
          @user.password = "aaaaaa"
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません", "Passwordは8文字以上で入力してください")
        end
        it "passwordが全角であれば登録できない" do
          @user.password = "ああああああ"
          @user.valid?
          expect(@user.errors.full_messages).to include("Password confirmationとPasswordの入力が一致しません", "Passwordは8文字以上で入力してください")
        end
        it "生年月日が空だと登録できない" do
          @user.birthday = nil
          @user.valid?
          expect(@user.errors.full_messages).to include("Birthdayを入力してください")
        end
        it "性別が入力されていないとき" do
          @user.sex = nil
          @user.valid?
          expect(@user.errors.full_messages).to include("Sexを入力してください")
        end
      end
    end

    describe 'パスワードの検証' do
      it 'パスワードと確認用パスワードが間違っている場合、無効であること' do
        @user.password = 'password'
        @user.password_confirmation = 'pass'
        @user.valid?
        expect(@user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
      end

      it 'パスワードが暗号化されていること' do
        expect(@user.encrypted_attributes).to_not eq 'password'
      end
    end

    describe 'フォーマットの検証' do
      it 'メールアドレスが正常なフォーマットの場合、有効であること' do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
          @user.email = valid_address
          expect(@user).to be_valid
        end
      end
    end

    describe 'フォローの検証' do
    it'ユーザーが他のユーザーをフォロー、フォロー解除可能である' do
      tester1   = FactoryBot.create(:user)
      tester2   = FactoryBot.create(:user)
      tester1.follow(tester2.id)
      expect(tester1.following?(tester2)).to eq true
      tester1.unfollow(tester2.id)
      expect(tester1.following?(tester2)).to eq false
    end

    it 'フォロー中のユーザーが削除されると、フォローが解消される' do
      tester1   = FactoryBot.create(:user)
      tester2   = FactoryBot.create(:user)
      tester1.follow(tester2.id)
      expect(tester1.following?(tester2)).to eq true
      tester1.destroy
      expect(tester1.following?(tester2)).to eq false
    end
  end
end
