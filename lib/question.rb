class Question < ActiveRecord::Base
  belongs_to :survey, :foreign_key => "survey_id", :class_name => "Survey"
end
