source 'https://rubygems.org'
ruby File.read('.ruby-version').chomp

# Application engine
gem 'rails', '~> 4.2.5'

# Server engine
gem 'unicorn'

# Database adapters
gem 'pg'

# Logging tools
gem 'logging'

# DSLs
gem 'slim-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'jbuilder'

# Vendor assets and frameworks
gem 'bootstrap-sass'
gem 'jquery-rails'

# Asset related tools
gem 'therubyracer'
gem 'uglifier'

# Pretty printing for debugging convenience
gem 'awesome_print', require: false

# Static pages
gem 'high_voltage'

# ActiveRecord extensions
gem 'globalize' # translations
gem 'paperclip' # attachments
gem 'friendly_id' # slugs

# Detect user preferred language
gem 'http_accept_language'

group :development do
  gem 'spring'
  gem 'byebug'
  gem 'web-console'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'quiet_assets'
end
