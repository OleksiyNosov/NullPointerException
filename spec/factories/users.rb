FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user#{ n }@example.com" }
    password { Faker::Internet.password }
    status { :confirmed }
  end
end
