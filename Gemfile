source 'https://rubygems.org'

gem 'rails', '3.2.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'json'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

# For awesome testing
group :development, :test do
  gem 'sqlite3'
  gem 'rb-fsevent', :require => false
  gem 'factory_girl_rails', "~> 1.2"
  gem 'capybara'
  gem 'guard-test'
  gem 'guard-livereload'
end

# For heroku
group :production do
  gem 'thin'
  gem 'pg'
end

# For Authentication
gem "devise"
gem "omniauth-facebook"

gem "jquery-rails"

gem 'bootstrap-sass', '~> 2.0.0'
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/rilya/twitter_bootstrap_form_for.git'
