source :rubygems

# gem 'rails', '3.1.0.rc6'
 gem 'rails',     :git => 'git://github.com/rails/rails.git', :branch => '3-1-stable'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'

#Files/Images
gem 'gravatar_image_tag'
gem 'paperclip', '~> 2.3'
gem 'aws-s3'

gem "will_paginate", :git => "https://github.com/p7r/will_paginate.git", :branch => "rails3"
gem 'rake', '0.8.7'

# Asset template engines
gem 'sprockets', :git => "https://github.com/sstephenson/sprockets.git"
gem 'sass-rails', "~> 3.1.0.rc.6"
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'


gem 'devise'
gem 'devise_invitable'

gem 'mail'

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
  gem 'populator'
  gem 'ruby-debug19'
  gem 'cucumber-rails'
  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
end
