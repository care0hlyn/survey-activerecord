require 'rspec'
require 'active_record'
require 'shoulda-matchers'
require 'bundler/setup'
Bundler.require(:default, :test)

database_configurations = YAML::load(File.open('./db/config.yml'))
test_configuration = database_configurations['test']
ActiveRecord::Base.establish_connection(test_configuration)

require 'survey'

RSpec.configure do |config|
  config.formatter = 'doc'
  config.before(:each) do
    Survey.all.each { |survey| survey.destroy }
  end
end
