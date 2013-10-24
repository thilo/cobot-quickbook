source 'https://rubygems.org'
ruby '2.0.0'

# Server requirements (defaults to WEBrick)
gem 'unicorn'

# Project requirements
gem 'rake'
gem 'oauth2'
gem 'oauth'
gem 'sentry-raven'
gem 'rack-ssl'

# Component requirements
gem 'erubis'
gem 'activerecord', :require => "active_record"
gem 'pg'
gem 'quickeebooks', git: 'git://github.com/cobot/quickeebooks.git'

# Test requirements
group "test" do
  gem 'rspec'
  gem 'rack-test', :require => "rack/test"
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'factory_girl', '~> 4.0'
end

group "development" do
  gem 'foreman'
end

# Padrino Stable Gem
gem 'padrino', '0.11.4'

