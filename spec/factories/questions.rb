FactoryBot.define do
  factory :question do
    title { Faker::RockBand.name }
    body { Faker::RickAndMorty.quote }
    tags { Array.new(rand 1..5) { Faker::Food.dish } }
  end
end
