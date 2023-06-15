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
