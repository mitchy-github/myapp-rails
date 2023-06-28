# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  activated                  :boolean          default(FALSE), not null
#  activated_at               :datetime
#  activation_digest          :string(255)
#  admin                      :boolean          default(FALSE), not null
#  birthday                   :date             not null
#  birthday_of_baby           :date
#  child_want                 :boolean
#  childcare_graduation_end   :date
#  childcare_graduation_start :date
#  childcare_start            :date
#  email                      :string(255)      not null
#  image                      :string(255)
#  months_pregnant            :integer
#  name                       :string(255)      not null
#  number_of_baby             :integer
#  password_digest            :string(255)      not null
#  region                     :string(255)      not null
#  remember_digest            :string(255)
#  reset_digest               :string(255)
#  reset_sent_at              :datetime
#  sex                        :boolean          not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :favorites, dependent: :destroy   #この行を追記
  has_many :chats, dependent: :destroy#データ残っている
  has_many :likes, dependent: :destroy

  has_many :question_answers, dependent: :destroy
  has_many :user_rooms, dependent: :destroy#データ残っている
  has_many :rooms, through: :user_rooms#データ残っている
  has_many :category_users, dependent: :destroy
  has_many :categories, through: :category_users

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users

  enum ride_area:{
    "---":0,
    北海道:1,青森県:2,岩手県:3,宮城県:4,秋田県:5,山形県:6,福島県:7,
    茨城県:8,栃木県:9,群馬県:10,埼玉県:11,千葉県:12,東京都:13,神奈川県:14,
    新潟県:15,富山県:16,石川県:17,福井県:18,山梨県:19,長野県:20,
    岐阜県:21,静岡県:22,愛知県:23,三重県:24,
    滋賀県:25,京都府:26,大阪府:27,兵庫県:28,奈良県:29,和歌山県:30,
    鳥取県:31,島根県:32,岡山県:33,広島県:34,山口県:35,
    徳島県:36,香川県:37,愛媛県:38,高知県:39,
    福岡県:40,佐賀県:41,長崎県:42,熊本県:43,大分県:44,宮崎県:45,鹿児島県:46,
    沖縄県:47
  }

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :sex, inclusion: [true, false]
  validates :birthday, presence: true
  validates :region, presence: true
  validates :password, presence: true, length: { minimum: 8 }
  # validates :password_digest, presence: true
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
    message: "有効なフォーマットではありません" },
    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }

  validate :birthday_date_check

  def birthday_date_check
    errors.add(:birthday,"に未来の日付は指定できません") if birthday.nil? || birthday > Date.today
  end

  def guest_user?
    email == 'guest@exapmle.com'
  end

  def user?(user)
    user.id == user.id
  end

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end
end
