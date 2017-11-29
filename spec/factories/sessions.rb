FactoryGirl.define do
  factory :session do
    user
    token { Faker::Internet.password(32) }
  end
end
