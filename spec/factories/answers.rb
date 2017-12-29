FactoryBot.define do
  factory :answer do
    question
    body { Faker::Lovecraft.paragraph }
  end
end
