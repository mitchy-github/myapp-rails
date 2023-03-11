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
  has_many :posts
  has_many :questions
  has_many :question_answers
  has_many :likes

  has_many :community_users
  has_many :communities, through: :community_users

  has_many :category_users
  has_many :categories, through: :category_users

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
end
