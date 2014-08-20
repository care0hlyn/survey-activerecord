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
  puts " '1' to create survey."
  puts " '2' to delete a survey."
  puts " '3' to update a survey."
  puts " 'x' to exit program."

  case gets.chomp
  when '1'
    create_survey
  when '2'
    delete_survey
  when '3'
    update_survey
  when 'x'
    exit
  else
    puts 'Invalid.'
    menu
  end
end

def create_survey
  header
  puts "Enter survey name:"
  name = gets.chomp
  puts "Enter topic:"
  topic = gets.chomp
  survey = Survey.create(name: name, topic: topic)
  puts "#{name}: #{topic} has been created."
  whitespace
  puts " '1' to add a question to the survey."
  puts " '2' to return to the main menu."
  case gets.chomp
  when '1'
    create_question
  when '2'
    menu
  else
    puts 'Invalid.'
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
end

def create_question
  header
  list_surveys
  puts "Enter the # of a survey to add a question to:"
  survey = Survey.find_by(id: gets.chomp.to_i)
  whitespace
  puts "Enter the new question:"
  question = Question.create(text: gets.chomp, survey_id: survey.id)
  whitespace
  puts "Enter an answer for the new question:"
  Answer.create(text: gets.chomp, question_id: question.id)
  puts "Enter another answer for the new question!:"
  Answer.create(text: gets.chomp, question_id: question.id)
  whitespace
  puts " '1' to add another question to the survey."
  puts " '2' to return to the main menu."
  case gets.chomp
  when '1'
    create_question
  when '2'
    menu
  else
    puts 'Invalid.'
  end
end

def list_questions
end

def create_answer
end

def list_answers
end

menu
