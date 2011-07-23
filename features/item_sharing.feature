Feature: Item Sharing
  In order to share items with other groups
  As a logged in user on their group's page
  I want to be able to share an item with a connected group

  Scenario: Logged in user sees their groups
    Given I am logged in
      And I belong to "Group A"
      And I do not belong to "Group B"
      And "Group A" is connected to "Group B"
      And I do not belong to "Group C"
    When I am on Group A's page
      And "Group A" shares a Todo with "Group B"
    Then I should see "Success" in the flash section
      And I should see "Group B" in the shared groups section
