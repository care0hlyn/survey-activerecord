require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def whitespace
  puts "\n"
end

def header
  system 'clear'
  puts "Surveys Wooo"
  whitespace
end

def menu
  header
  puts "Main Menu"
  whitespace
  puts " '1' to take a survey."
  puts " '2' to manage surveys."
  puts " '3' to exit program."
  case gets.chomp
  when '1'
    take_survey
  when '2'
    survey_menu
  when '3'
    exit
  else
    puts 'Invalid.'
    menu
  end
end

def survey_menu
  header
  puts "Survey Menu"
  whitespace
  puts " '1' Create a new survey."
  puts " '2' Edit a survey."
  puts " '3' Delete a survey."
  puts " '4' Return to main menu."
  case gets.chomp
  when '1'
    create_survey
  when '2'
    edit_survey
  when '3'
    delete_survey
  when '4'
    menu
  end
end

def take_survey
  list_surveys
  puts "Enter # to take survey."
  @current_survey = Survey.find_by(id: gets.chomp.to_i)

  @current_survey.questions.each do |question|
    puts "#{question.text}"
    whitespace
    puts "Choices:"
    question.answers.each do |answer|
      puts "#{answer.id}) #{answer.text} "
    end
    whitespace
    puts "Enter the number of your choice:"
    response = gets.chomp.to_i
  end
end

def create_survey
  header
  puts "Enter the name of the survey:"
  name = gets.chomp
  puts "Enter the topic of the survey:"
  topic = gets.chomp
  Survey.create(name: name, topic: topic)
  survey_menu
end

def edit_survey
  header
  list_surveys
  puts "Enter the number of a survey to edit:"
  @current_survey = Survey.find(gets.chomp.to_i)
  view_survey
end

def view_survey
  header
  puts "Viewing Survey: #{@current_survey.name}."
  whitespace
  puts " Questions"
  puts "-----------"
  whitespace
  list_questions
  puts " '1' Add a new question."
  puts " '2' Edit a question"
  puts " '3' Delete a question."
  puts " '4' Return to Surveys Menu."
  case gets.chomp
  when '1'
    create_question
  when '2'
    edit_question
  when '3'
    delete_question
  when '4'
    survey_menu
  end
end

def list_surveys
  puts "Surveys"
  puts "---------"
  Survey.all.each do |survey|
    puts survey.id.to_s + " - " + survey.name + " | " + survey.topic
  end
  whitespace
end

def delete_survey
  list_surveys
  puts "Enter # to remove survey from list."
  survey = Survey.find_by(id: gets.chomp.to_i)
  survey.destroy
  survey_menu
end

def delete_question
  list_questions
  puts "Enter # to remove question from list."
  question = Question.find_by(id: gets.chomp.to_i)
  question.destroy
  survey_menu
end

def delete_answer
  list_answers
  puts "Enter # to remove answer from list."
  answer = Answer.find_by(id: gets.chomp.to_i)
  answer.destroy
  view_question
end

def create_question
  header
  puts "Adding a question to Survey: #{@current_survey.name}."
  whitespace
  puts "Enter a new question:"
  Question.create(text: gets.chomp, survey_id: @current_survey.id)
  view_survey
end

def edit_question
  header
  list_questions
  puts "Enter the number of a question to edit:"
  @current_question = Question.find(gets.chomp.to_i)
  view_question
end

def view_question
  puts " Question: #{@current_question.text} "
  list_answers
  puts " '1' Add a new answer."
  puts " '2' Delete an answer"
  puts " '3' Return to Survey Menu."
  case gets.chomp
  when '1'
    create_answer
  when '2'
    delete_answer
  when '3'
    survey_menu
  end
end

def list_questions
  @current_survey.questions.each do |question|
    puts " #{question.id}) #{question.text}"
    puts " Answers:"
    question.answers.each do |answer|
      puts " #{answer.text} "
    end
  whitespace
  end
end

def create_answer
  header
  puts "Add an answer to question: #{@current_question.text}."
  whitespace
  puts "Enter an answer for this question:"
  answer = Answer.create(text: gets.chomp, question_id: @current_question.id)
  whitespace
  view_question
end

def list_answers
  puts " Answers"
  puts "---------"
  whitespace
  @current_question.answers.each do |answer|
    puts " #{answer.id}) #{answer.text}"
  end
  whitespace
end

menu
