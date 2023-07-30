# == Schema Information
#
# Table name: posts
#
#  id           :bigint           not null, primary key
#  post_content :text(4294967295) not null
#  post_title   :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
FactoryBot.define do
  factory :post do
    post_title { Faker::Hacker.say_something_smart }
    post_content { Faker::Hacker.say_something_smart }
    user

    trait :invalid do
      post_title { "" }
    end
  end

  factory :takaship, class: Post do
    post_title { "Takaship" }
    post_content { "takashi@example.com" }
    user
  end

  factory :satoship, class: Post do
    post_title { "Satoship" }
    post_content { "satoshi@example.com" }
    user
  end
end
