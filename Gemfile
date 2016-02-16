source 'https://rubygems.org'
ruby File.read('.ruby-version').chomp

gem 'rails', '~> 4.2.5'

# Database adapters
gem 'pg'

# DSLs
gem 'slim-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'jbuilder'

# Vendor assets and frameworks
gem 'bootstrap-sass'
gem 'jquery-rails'

# Asset related tools
gem 'uglifier'
gem 'therubyracer', platforms: :ruby

# Core extensions
gem 'awesome_print', require: false

gem 'globalize'
gem 'friendly_id'
gem 'http_accept_language'

group :production do
  gem 'unicorn'
end

group :development do
  gem 'spring'
  gem 'byebug'
  gem 'web-console'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'quiet_assets'
end
