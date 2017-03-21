source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Core
gem 'rails', '~> 5.0.1'
gem 'puma', '~> 3.0'
gem 'pg', '~> 0.18'
gem 'rack-cors'
gem "dotenv-rails"
gem 'slim'
gem 'sidekiq'
gem 'mailgun_rails'

# API
gem 'grape', '~> 0.19.1'
gem 'grape-entity', '~> 0.6.1'
gem 'grape_on_rails_routes'
gem 'hashie-forbidden_attributes'
gem 'kaminari', '~> 0.17.0'
gem 'api-pagination', '~> 4.5.2'

# Data layer stuff
gem 'paperclip', '~> 5.0.0'
gem 'email_validator'
gem 'searchlight'
gem 'ffaker'

# Debugging
gem 'pry-rails'

# Authentication
gem 'oauth2'
gem 'jwt'
gem 'devise'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'foreman'
  gem 'letter_opener'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
