# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

#  def test_sign_in(user)
#    #controller.sign_in(user) #BREAKS SIGNIN TESTS
#    controller.current_user = user
#  end

  def test_sign_in(user)
    sign_in user
    user.confirm!
  end

  def integration_sign_in(user)
    user.confirm!
    visit new_user_session_path
    fill_in 'Email',     :with => user.email
    fill_in 'Password',  :with => user.password
    click_button 'Sign in'
  end

  def integration_make_group
    visit new_group_path
    fill_in 'Name', :with => "Group Name"
    fill_in 'About', :with => "About us: We're a group"
    check 'group_agreement'
    click_button 'Create Group'
    current_path
  end

  def integration_make_todo(url)
    url += '/todos/new'
    visit url
    #click_link 'Add a Todo'
    fill_in 'Title', :with => "Test Todo"
    fill_in 'Task', :with => "Here's a test task"
    click_button 'Create List'
  end

end
