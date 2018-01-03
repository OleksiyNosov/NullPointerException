FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    email_confirmation { true }
    confirmation_token { SecureRandom.urlsafe_base64.to_s }
  end
end
