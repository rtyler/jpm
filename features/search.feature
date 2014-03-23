Feature: Search for plugins
  As a Jenkins user
  I should be able to search for plugins with jpm
  Without necessarily needing Jenkins to be installed


  Scenario: Searching for a plugin by name
    Given I have catalog meta-data
    When I run `jpm search ansicolor`
    Then the output should contain:
      """
      Loading plugin repository data...

      - AnsiColor Plugin (ansicolor)
        version: v0.3.1
         labels: misc
           wiki: <https://wiki.jenkins-ci.org/display/JENKINS/AnsiColor+Plugin>

      """


