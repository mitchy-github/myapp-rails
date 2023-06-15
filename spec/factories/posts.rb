FactoryBot.define do
  factory :post do
    post_title { Faker::Hacker.say_something_smart }
    post_content { Faker::Hacker.say_something_smart }
    user
  end
end
