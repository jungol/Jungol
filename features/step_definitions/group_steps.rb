When /^"([^""]*)" shares a Todo with "([^""]*)"$/ do |group1, group2|
  Given "\"#{group1}\" has a Todo"
    And "I am on #{group1}'s page"
    And "I follow \"Something\""
    And "I press \"Share\""
end

Given /^"([^""]*)" is connected to "([^""]*)"$/ do |group, group2|
    When "I am on #{group}'s page"
      And "I follow \"Connect to Groups\""
      And "I select \"#{group2}\" from \"group_id\""
      And "I press \"Connect to Group\""
end

Given /^"([^""]*)" has a Todo$/ do |group|
  When "I am on #{group}'s page"
    And "I follow \"Add a Todo\""
    And "I fill in \"Title\" with \"Something\""
    And "I press \"Create List\""
end

Then /^I should see "([^""]*)" in the shared groups section$/ do |arg1|
  page.should_not have_content "No Groups yet."
end

