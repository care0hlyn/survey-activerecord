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
  puts " '1' User menu."
  puts " '2' Survey menu."
  puts " '3' Exit program."
  case gets.chomp
  when '1'
    user_menu
  when '2'
    survey_menu
  when '3'
    exit
  else
    puts 'Invalid.'
    menu
  end
end

def user_menu
  header
  puts " '1' Create new user."
  puts " '2' Delete user."
  puts " '3' Update user."
  puts " '4' View users."
  puts " '5' Main menu."
  case gets.chomp
  when '1'
    create_user
  when '2'
    delete_user
  when '3'
    update_user
  when '4'
    view_users
  when '5'
    menu
  end
end

def create_user
  header
  puts "Enter user name:"
  user = User.create(name: gets.chomp)
  puts "#{user.name} has been added."
  user_menu
end

def delete_user
  header
  view_users
  puts "Enter # of user to delete."
  user = User.find_by(id: gets.chomp.to_i)
  user.destroy
  user_menu
end

def update_user
  header
  view_users
  puts "Enter # of user to update."
  user = User.find_by(id: gets.chomp.to_i)
  puts "Enter a new name for the user:"
  user.update(name: gets.chomp)
  puts "#{user.name} has been updated!"
  sleep 0.5
  user_menu
end

def view_users
  puts "Users"
  puts "------"
  User.all.each do |user|
    puts user.id.to_s + " - " + user.name
  end
  whitespace
end

def survey_menu
  header
  puts " '1' Take a survey."
  puts " '2' Manage surveys."
  puts " '3' View results."
  puts " '4' Main menu."
  case gets.chomp
  when '1'
    take_survey
  when '2'
    manage_surveys
  when '3'
    view_results
  when '4'
    menu
  else
    puts 'Invalid.'
    menu
  end
end

def view_results
  header
  list_surveys
  puts "Enter survey # to view results:"
  @current_survey = Survey.find_by(id: gets.chomp.to_i)

  header
  puts "Viewing Survey: #{@current_survey.name}"
  whitespace
  total = 0.0
  count = 0.0
  # percentage = (answers.length / questions.length)*100

  @current_survey.questions.each do |question|
    total += question.responses.length
    puts "#{question.id}) #{question.text}"
    puts "Number of Responses = #{total}"
    puts "Answers:"
    question.answers.each do |answer|
      count += answer.responses.length
      percentage = (count/total * 100).to_i
      puts "#{answer.text}" + " | " + "Picked: #{count.to_i}, #{percentage}%"
      count = 0.0
    end
  whitespace
  total = 0.0
  end
end

def manage_surveys
  header
  puts "Manage Surveys"
  whitespace
  puts " '1' Create a new survey."
  puts " '2' Edit a survey."
  puts " '3' Delete a survey."
  puts " '4' Main menu."
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
  header
  view_users
  puts "Enter # choose a user:"
  @current_user = User.find_by(id: gets.chomp.to_i)

  header
  list_surveys
  puts "Enter # to take survey."
  @current_survey = Survey.find_by(id: gets.chomp.to_i)

  header
  puts " #{@current_user.name} is taking Survey: #{@current_survey.name}"
  whitespace
  @current_survey.questions.each do |question|
    puts "#{question.text}?"
    whitespace
    puts "Choices:"
    question.answers.each do |answer|
      puts "#{answer.id}) #{answer.text} "
    end
    whitespace
    puts "Enter the number of your choice:"
    Response.create(survey_id: @current_survey.id, user_id: @current_user.id, question_id: question.id, answer_id: gets.chomp.to_i)
  end
  survey_menu
end

def create_survey
  header
  puts "Enter the name of the survey:"
  name = gets.chomp
  puts "Enter the topic of the survey:"
  topic = gets.chomp
  Survey.create(name: name, topic: topic)
  manage_surveys
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
  puts " '4' Manage Surveys."
  case gets.chomp
  when '1'
    create_question
  when '2'
    edit_question
  when '3'
    delete_question
  when '4'
    manage_surveys
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
  manage_surveys
end

def delete_question
  list_questions
  puts "Enter # to remove question from list."
  question = Question.find_by(id: gets.chomp.to_i)
  question.destroy
  manage_surveys
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
  puts " '3' Manage Surveys."
  case gets.chomp
  when '1'
    create_answer
  when '2'
    delete_answer
  when '3'
    manage_surveys
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
