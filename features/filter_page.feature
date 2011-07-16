Feature: Filter Page
  In order to visualize my groups' work
  As a logged in user on the filter page
  I want to see groups that I'm a member of and their items

  Scenario: Logged in user sees their groups
    Given I belong to "Group A"
      And I belong to "Group B"
      And I do not belong to "Group C"
      And I am logged in
    When I am on the filter page
    Then I should see "Group A" in the your groups section
      And I should see "Group B" in the your groups section
      And I should not see "Group C" in the your groups section
