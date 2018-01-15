FactoryBot.define do
  factory :answer do
    question
    user
    body { Faker::Lovecraft.paragraph }
  end
end
