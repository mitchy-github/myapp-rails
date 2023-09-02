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
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }

    context '内容に問題がない場合' do
      it '表示されること' do
        expect(post).to be_valid
      end
    end
  end

  describe 'バリデーションチェック' do
    let!(:user) { create(:user) }
    let!(:post) { create(:post, user_id: user.id) }
    let!(:title_is_blank) { build(:post, user_id: user.id, post_title: '') }
    let!(:title_length) { build(:post, user_id: user.id, post_title: 'a' * 110) }
    let!(:contents_is_blank) { build(:post, user_id: user.id, post_content: '') }

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

    before do
      create(:favorite, user: user_2, post: post_1)
    end

    context '投稿にいいねしている場合' do
      it 'trueを返すこと' do
        expect(post_1.favorited_by?(user_2)).to eq true
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
    let!(:user) { create(:user) }
    let!(:post) { create(:post) }
    let!(:other_user) { create(:user) }
    let!(:favorite) { create(:favorite, user: user, post: post) }

    context '指定されたユーザーのお気に入りが存在する場合' do
      it 'trueを返すこと' do
        expect(post.favorited_by?(user)).to be_truthy
      end
    end

    context '指定されたユーザーのお気に入りが存在しない場合' do
      it 'falseを返すこと' do
        expect(post.favorited_by?(other_user)).to be_falsy
      end
    end
  end
end
