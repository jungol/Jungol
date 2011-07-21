source :rubygems

gem 'rails', '3.1.0.rc4'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'

gem 'gravatar_image_tag'
gem "will_paginate", :git => "https://github.com/p7r/will_paginate.git", :branch => "rails3"
gem 'rake', '0.8.7'

# Asset template engines
gem 'sass-rails', "~> 3.1.0.rc"
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

gem 'devise'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

#add rubyracer as js engine for heroku

group :production do
#   gem 'therubyracer-heroku', '0.8.1.pre3'
    gem "therubyracer", :git => "https://github.com/cowboyd/therubyracer.git", :branch => "locktight"
end

group :development, :test do
#  gem 'rails-erd'
  gem 'rspec-rails'
  gem 'annotate'
  gem 'faker'
  gem 'ruby-debug19'
  gem 'cucumber-rails'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end
