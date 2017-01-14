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
gem 'grape'
gem 'grape_on_rails_routes'
gem 'slim'
gem 'sidekiq'
gem 'mailgun_rails'
gem "open_uri_w_redirect_to_https"

# Data layer stuff
gem "carrierwave", '~> 1.0.0'
gem "carrierwave-base64"
gem 'carrierwave_backgrounder', github: 'nicooga/carrierwave_backgrounder'
gem 'email_validator'
gem 'grape-active_model_serializers'
gem 'hashie-forbidden_attributes'

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
