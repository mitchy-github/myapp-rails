require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーションチェック' do
    #factoriesで作成したダミーデータを使用する
    let(:user) {create(:user)}
    let!(:post) {build(:post, user_id: user.id)}
    #test_postを作成し、空欄での登録ができるか確認
    subject {test_post.valid?}
    let(:test_post) {post}

    context 'titleカラムが空欄でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_post.post_title = ''
        is_expected.to eq false;
      end
    end

    context 'contentカラムが空欄でないこと' do
      it 'バリデーションエラーが発生すること' do
        test_post.post_content = ''
        is_expected.to eq false;
      end
    end
  end

  describe '#create' do
    let!(:post) {build(:post)}

    context 'imageが存在する場合' do
      it 'imageが登録できること' do
        # post.images = fixture_file_upload("spec/fixtures/files/fixture.jpg")
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures','files', 'fixture.jpg'), 'image/jpeg')
        post.images.attach(file)
        expect(post).to be_valid
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
end
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
