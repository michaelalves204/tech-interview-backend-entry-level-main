# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.3.1'
gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'redis', '~> 5.2'
gem 'sidekiq', '~> 8.1', '>= 8.1.3'
gem 'sidekiq-scheduler', '~> 6.0', '>= 6.0.2'

gem 'dry-validation', '~> 1.11', '>= 1.11.1'
gem 'guard'
gem 'guard-livereload', require: false

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails', '~> 6.5', '>= 6.5.1'
  gem 'rspec-rails', '~> 6.1.0'
end

group :development do
  gem 'brakeman', '~> 6.0'
  gem 'bundle-audit', '~> 0.2.0'
  gem 'rubocop-rails-omakase', '~> 1.1'
end

group :test do
  gem 'simplecov', '~> 0.22.0'
end
