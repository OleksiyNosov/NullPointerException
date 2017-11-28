puts 'Creating seeds'

questions_length = 100
answers_length = 1000

puts "Generating #{ questions_length } questions"
questions = FactoryGirl.create_list(:question, questions_length)

puts "Generating #{ answers_length } answers"
Array.new(answers_length) { FactoryGirl.create(:answer, question: questions.sample) }

puts 'Done'
