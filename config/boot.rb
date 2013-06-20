# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'raven'
Bundler.require(:default, PADRINO_ENV)

##
# Enable devel logging
Padrino::Logger::Config[:development] = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:test] = { :log_level => :debug, :stream => :to_file }
Padrino::Logger::Config[:production] = { :log_level => :error, :stream => :stdout }
#
# Padrino::Logger::Config[:development] = { :log_level => :devel, :stream => :stdout }
# Padrino::Logger.log_static = true
#

Raven.configure do |config|
  config.dsn = 'https://e4b1141328db4f6f951d570121e1f780:889da53a844d461b9ba7ac76423ada4f@app.getsentry.com/9801'
end

##
# Add your before load hooks here
#
Padrino.before_load do
end

##
# Add your after load hooks here
#
Padrino.after_load do
end

Padrino.load!
