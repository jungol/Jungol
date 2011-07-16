Given /^I belong to "([^"]*)"$/ do |group_name|
  default_user.groups.create :name => group_name
end

Given /^I do not belong to "([^"]*)"$/ do |group_name|
  creator = Factory(:user)
  creator.groups.create :name => group_name
end

Given /^I am logged in$/ do
  When "I am on the signin page"
  And "I fill in \"Email\" with \"#{default_user.email}\""
  And "I fill in \"Password\" with \"#{default_user.password}\""
  And "I press \"Sign in\""
end

private

def default_user
  @default_user ||= Factory(:user)
end
