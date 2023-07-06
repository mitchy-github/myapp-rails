FactoryBot.define do
  factory :question do
    question_title { Faker::Hacker.say_something_smart }
    contents_question { Faker::Hacker.say_something_smart }
    user
  end
end
