class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only:[:new, :edit, :update, :destroy]

  def index
    @posts = Post.includes(:user)
  end

  def show
    @user = User.find_by(id: @post.user_id)
    @post = Post.includes(:user).find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    # binding.pry
    @post = Post.new(post_params)
    @post.save!
      redirect_to posts_path, notice: "投稿しました"
    rescue StandardError
      render "new", status: :unprocessable_entity
  end

  def update
    unless logged_in? && @post.user_post?(current_user) && @post.update(post_params)
      render "edit", status: :unprocessable_entity and return
    end

    redirect_to posts_path, notice: "更新しました"

    # if @post.update(post_params)
    #   redirect_to posts_path, notice: "更新しました"
    # else
    #   render "edit", status: :unprocessable_entity
    # end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "削除しました", status: :see_other
  end

  # 画像アップロード用のアクション
  def upload_image
    @image_blob = create_blob(params[:image])
    render json: @image_blob
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  # 選択状態の画像をパラメータにマージ（Postモデルとの紐付け）
  def post_params
    params.require(:post).permit(:post_title, :post_content).merge(images: uploaded_images, user_id:current_user.id)
  end

  # アップロード済み画像の検索
  def uploaded_images
    params[:post][:images].drop(1).map{|id| ActiveStorage::Blob.find(id)} if params[:post][:images]
  end

  # blobデータの作成
  def create_blob(file)
    ActiveStorage::Blob.create_and_upload!(
      io: file.open,
      filename: file.original_filename,
      content_type: file.content_type
    )
  end
end
