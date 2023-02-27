# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'
gem 'activerecord-multi-tenant'
gem 'ancestry'
gem 'bootsnap', require: false
gem 'friendly_id'
gem 'graphql', '~> 2.0'
gem 'httparty'
gem 'pg'
gem 'pry-rails'
gem 'puma'
gem 'rails', '~> 7.0.4', '>= 7.0.4.2'
gem 'redis', '~> 4.0'
gem 'sprockets-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'graphiql-rails'
  gem 'rubocop', require: false
  gem 'rubocop-graphql', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
end

group :test do
  gem 'faker'
  gem 'shoulda-matchers'
end
