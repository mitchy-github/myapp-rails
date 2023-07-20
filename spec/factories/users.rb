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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    name { Faker::Name.name }
    sex { "1" }
    birthday {  "2020-01-01" }
    region {  "東京都" }
  end
end
