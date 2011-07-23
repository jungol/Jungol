Given /^I belong to "([^"]*)"$/ do |group_name|
  default_user.created_groups.create :name => group_name, :about => "We're #{group_name}!", :agreement => "1"
end

Given /^I do not belong to "([^"]*)"$/ do |group_name|
  creator = Factory(:confirmed_user)
  creator.created_groups.create :name => group_name, :about => "We're #{group_name}!", :agreement => "1"
end

Then /^I should see "([^""]*)" in the your groups section$/ do |arg1|
  When "I am on my profile page"
    page.should have_content arg1
end

Then /^I should not see "([^""]*)" in the your groups section$/ do |arg1|
  When "I am on my profile page"
    page.should_not have_content arg1
end


Given /^I am logged in$/ do
  When "I am on the signin page"
  And "I fill in \"Email\" with \"#{default_user.email}\""
  And "I fill in \"Password\" with \"#{default_user.password}\""
  And "I press \"Sign in\""
end

private

def default_user
  @default_user ||= Factory(:confirmed_user)
end
