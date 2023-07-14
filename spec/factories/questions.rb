# == Schema Information
#
# Table name: questions
#
#  id                :bigint           not null, primary key
#  contents_question :text(65535)      not null
#  question_title    :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  best_answer_id    :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
FactoryBot.define do
  factory :question do
    question_title { Faker::Hacker.say_something_smart }
    contents_question { Faker::Hacker.say_something_smart }
    user
  end
end
