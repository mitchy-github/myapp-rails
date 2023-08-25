FactoryBot.define do
  factory :session do
    email { Faker::Internet.unique.email }
    password { '12345678' }
  end
end
