FactoryBot.define do
  factory :question do
    user
    title { Faker::RockBand.name }
    body { Faker::RickAndMorty.quote }
  end
end
