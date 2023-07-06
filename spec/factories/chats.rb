FactoryBot.define do
  factory :chat do
    message { Faker::Hacker.say_something_smart }
    user
  end
end
