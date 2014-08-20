class Question < ActiveRecord::Base
  belongs_to :survey, :foreign_key => "survey_id", :class_name => "Survey"
  has_many :answers
  has_many :responses
end
