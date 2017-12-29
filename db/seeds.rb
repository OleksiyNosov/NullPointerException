puts 'Creating seeds'

users_length = 100
questions_length = 100
answers_length = 1000

puts "Generating #{ users_length } users"
FactoryBot.create_list(:user, users_length)

puts "Generating #{ questions_length } questions"
questions = FactoryBot.create_list(:question, questions_length)

puts "Generating #{ answers_length } answers"
Array.new(answers_length) { FactoryBot.create(:answer, question: questions.sample) }

puts 'Done'
