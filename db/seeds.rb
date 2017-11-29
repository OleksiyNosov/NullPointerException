puts 'Creating seeds'

users_length = 100
sessions_length = users_length
questions_length = 100
answers_length = 1000

puts "Generating #{ users_length } users"
users = FactoryGirl.create_list(:user, users_length)

puts "Generating #{ sessions_length } users sessions"
Array.new(sessions_length) { |i| FactoryGirl.create(:session, user: users[i]) }

puts "Generating #{ questions_length } questions"
questions = FactoryGirl.create_list(:question, questions_length)

puts "Generating #{ answers_length } answers"
Array.new(answers_length) { FactoryGirl.create(:answer, question: questions.sample) }

puts 'Done'
