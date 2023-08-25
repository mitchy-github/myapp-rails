# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  post_content :text(4294967295) not null
#  post_title   :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe '内容に問題がないかのチェック' do
    #factoriesで作成したダミーデータを使用する
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    #test_postを作成し、空欄での登録ができるか確認
    # subject { test_post.valid? }
    # let(:test_post) { post }

    context '内容に問題がない場合' do
      it '表示されること' do
        expect(post).to be_valid
      end
    end
  end

  describe 'バリデーションチェック' do
    #factoriesで作成したダミーデータを使用する
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:title_is_blank) { build(:post, user_id: user.id, post_title: '') }
    let!(:title_length) { build(:post, user_id: user.id, post_title: 'a' * 110) }
    let!(:contents_is_blank) { build(:post, user_id: user.id, post_content: '') }
    #test_postを作成し、空欄での登録ができるか確認
    # subject { test_post.valid? }
    # let(:test_post) { post }

    context 'post_titleカラムが空欄でない場合' do
      it 'バリデーションエラーが発生すること' do
        title_is_blank.valid?
        expect(title_is_blank.errors.full_messages).to eq ["タイトルを入力してください"]
      end
    end

    context 'post_titleカラムが100文字以上の場合' do
      it 'バリデーションエラーが発生すること' do
        title_length.valid?
        expect(title_length.errors.full_messages).to eq ["タイトルは100文字以内で入力してください"]
      end
    end

    context 'post_contentカラムが空欄でない場合' do
      it 'バリデーションエラーが発生すること' do
        contents_is_blank.valid?
        expect(contents_is_blank.errors.full_messages).to eq ["投稿内容を入力してください"]
      end
    end
  end

  describe '#uploaded_images' do
    let!(:post) { create(:post) }

    context 'imageが存在する場合' do
      it 'imageが登録できること' do
        # post.images = fixture_file_upload("spec/fixtures/files/fixture.jpg")
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures','files', 'fixture.jpg'), 'image/jpeg')
        post.images.attach(file)
        expect(post).to be_valid
      end
    end
  end

  describe '#favorited_by?' do
    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }
    let!(:user_3) { create(:user) }
    let!(:post_1) { create(:post, user: user_1) }
    let!(:post_2) { create(:post, user: user_2) }
    # let!(:favorite) { create(:favorite, user: user_2, post: post_1) }
    # let!(:tester_3) { build(:post, user: user_3) }
    # let!(:favorite) { create(:favorite, user: user_2, post_id: tester_2.id) }
    # let(:post_1) {build(:post)}
    # let(:post_2) {build(:post)}
    # let(:tester_1) { build(post_id: post_1.id, user_id: user_1.id) }
    # let(:tester_2) { build(post_id: post_2.id, user_id: user_2.id) }

    before do
      create(:favorite, user: user_2, post: post_1)
    end

    context '投稿にいいねしている場合' do
      it 'trueを返すこと' do
        # tester_1.favorites
        # tester_2 = Post.find(tester_2.id)
        # favorite = tester_1.favorites.new(tester_2.id)
        # favorite = post_1.favorites.new(user_id: user_2.id, post_id: post_2.id)
        # favorite.save
        expect(post_1.favorited_by?(user_2)).to eq true
        # expect { tester_1.favorited_by?(tester_2) } .to change { tester_1.favorites.count }.by(1)
      end
    end

    context '投稿にいいねしていない場合' do
      it 'falseを返すこと' do
        expect(post_1.favorited_by?(user_3)).to eq false
      end
    end
  end

  describe '#user_post?' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let!(:post) { create(:post, user_id: user_a.id) }

    context '投稿者本人の場合' do
      it 'trueを返すこと' do
        expect(post.user_post?(user_a)).to be_truthy
      end
    end

    context '投稿者本人ではない場合' do
      it 'falseを返すこと' do
        expect(post.user_post?(user_b)).to be_falsy
      end
    end
  end

  describe '#favorited_by?' do
    let!(:user) { create(:user) } # Assuming you have a user factory set up with FactoryBot
    let!(:post) { create(:post) }
    let!(:other_user) { create(:user) }
    let!(:favorite) { create(:favorite, user: user, post: post) } # Assuming you have a favorite factory

    context '指定されたユーザーのお気に入りが存在する場合' do
      it 'trueを返すこと' do
        expect(post.favorited_by?(user)).to be_truthy
        # expect { favorite.favorited_by?(user.id) }.to change { Favorite.count }.by(1)
      end
    end

    context '指定されたユーザーのお気に入りが存在しない場合' do
      it 'falseを返すこと' do
        expect(post.favorited_by?(other_user)).to be_falsy
      end
    end
  end
end

  # 下記のテストはモデルspecではない？
  # describe '#create' do
  #   let(:user_a) { create(:user) }
  #   let(:user_b) { create(:user) }
  #   let(:user_c) { create(:user) }
  #   let!(:post_by_user_a) { create(:post, user_id: user_a.id) }
  #   let!(:post_by_user_b) { create(:post, user_id: user_b.id) }
  #   let!(:post_by_user_c) { create(:post, user_id: user_c.id) }

  #   context "likeの確認" do
  #     it 'likeできること' do
  #         expect { user_a.favorites(post_by_user_b.id) }.to change { Favorite.count }.by(1)
  #     end

  #     it 'likeが解除できること' do
  #         user_a.favorites(post_by_user_b.id)
  #         expect { user_a.unlike(post_by_user_b.id) }.to change { Favorite.count }.by(-1)
  #     end

  #     it 'お気に入りしているか確認できる お気に入りしている場合' do
  #         user_a.favorites(post_by_user_b.id)
  #         expect(user_a.favorited_by?(post_by_user_b)).to eq true
  #     end

  #     it 'お気に入りしていない場合' do
  #         expect(user_a.favorite_by?(post_by_user_c)).to eq false
  #     end
  #   end
  # end
# end
    # let(:user) {FactoryBot.create(:user)}
    # let!(:post) {build(:post, user_id: user.id)}
  #   # before do
  #   #   @image = build(:post)
  #   #   @image.images = fixture_file_upload("spec/fixtures/image/fixture.jpg")
  #   # end

  #   # context '...' do
  #   #   before{ @image_blob.image = fixture_file_upload('spec/fixtures/files/fixture.png')}
  #   #   it 'is valid with an image' do
  #   #     expect(@image_blob.image).to be_valid
  #   #   end
  #   # end

  #   # 1. imageが存在すれば登録できること
