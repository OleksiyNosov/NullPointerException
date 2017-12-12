FactoryBot.define do
  factory :question do
    title { Faker::RockBand.name }
    body { Faker::RickAndMorty.quote }
  end
end
