When /^"([^""]*)" shares a Todo with "([^""]*)"$/ do |group1, group2|
  Given "\"#{group1}\" has a Todo"
  And "I am on #{group1}'s page"
  And "I follow \"Something\""
  expect{
    And "I press \"Share\""
  }.to change(ItemShare, :count).by(1)
end

Given /^"([^""]*)" is connected to "([^""]*)"$/ do |group, group2|
  When "I am on #{group}'s page"
  And "I follow \"Connect to Groups\""
  And "I select \"#{group2}\" from \"group_id\""
  expect {
    And "I press \"Connect to Group\""
  }.to change(Group.find_by_name(group).groups, :count).by(1)
end

Given /^"([^""]*)" has a Todo$/ do |group|
  When "I am on #{group}'s page"
  And "I follow \"Add a Todo\""
  And "I fill in \"Title\" with \"Something\""
  expect{
    And "I press \"Create List\""
  }.to change(Todo, :count).by(1)
end

Then /^I should see "([^""]*)" in the shared groups section$/ do |arg1|
  page.should_not have_content "No Groups yet."
end

