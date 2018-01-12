puts 'Creating seeds'

users_size = 50
questions_size = 50
answers_size = 250

puts "Generating #{ users_size } users"
users = FactoryBot.create_list(:user, users_size)

puts "Generating #{ questions_size } questions"
questions = FactoryBot.create_list(:question, questions_size)

puts "Generating #{ answers_size } answers"
Array.new(answers_size) { FactoryBot.create(:answer, question: questions.sample, user: users.sample) }

puts 'Done'
