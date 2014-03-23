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
