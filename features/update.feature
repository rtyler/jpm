@announce
Feature: Update the plugin repository
  As a Jenkins user
  On a Jenkins master host
  I should be able to update the plugin repo with jpm

  @network
  Scenario: Updating without an existing update-center.json
    Given an update-center.json doesn't already exist
    When I run `jpm update`
    Then the exit status should be 0
    And the output should contain:
      """
      Fetching <http://updates.jenkins-ci.org/update-center.json> ...

      Wrote to ./update-center.json
      """

  @network
  Scenario: Updating with an existing update-center.json on disk
    Given an update-center.json already exists
    When I run `jpm update --force`
    And the output should contain:
      """
      Fetching <http://updates.jenkins-ci.org/update-center.json> ...

      Wrote to ./update-center.json
      """


  Scenario: Updating with a custom update-center.json URL
    Given I have a site with a custom update-center.json
    When I run `jpm update --source=http://aruba.bdd/update-center.json`
    Then the exit status should be 0
    And the output should contain:
      """
      Fetching <http://aruba.bdd/update-center.json> ...

      Wrote to ./update-center.json
      """
