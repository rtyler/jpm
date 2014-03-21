Feature: List installed plugins
  As a Jenkins user
  When I run jpm on a Jenkins master
  It should tell me what plugins are installed


  Scenario: Listing without Jenkins installed
    Given Jenkins isn't installed
    When I run `jpm list`
    Then the output should contain:
      """
      Jenkins is not installed!
      """

  Scenario: Listing with Jenkins installed and no plugins

      This isn't really all that likely, since Jenkins has some plugins
      built-in that unpack into /var/lib/jenkins/plugins after installation,
      but let's just pretend

    Given Jenkins is installed
    And there are no plugins available
    When I run `jpm list`
    Then the output should contain:
      """
      No plugins found
      """

  Scenario: Listing with Jenkins installed with plugins
    Given Jenkins is installed
    And there are plugins available
    When I run `jpm list`
    Then the output should contain:
      """
       - ant (1.1)
       - greenballs (1.0)
      """
