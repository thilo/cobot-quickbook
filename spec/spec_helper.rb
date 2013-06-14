PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara/rspec'
require 'database_cleaner'
require 'webmock/rspec'
# in spec/support/ and its subdirectories.
Dir[File.dirname(__FILE__) + ("/support/**/*.rb")].each {|f| require f}

Capybara.app = CobotFb


# Capybara.configure do |config|
#   config.match = :one
#   config.exact_options = true
#   config.ignore_hidden_elements = true
#   config.visible_text_only = true
# end

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods  

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
  
end

def app
  CobotFb.tap { |app|  }
end
