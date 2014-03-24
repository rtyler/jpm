Feature: Install a plugin
  As a Jenkins user
  When I run jpm on a Jenkins master
  It should allow me to install plugins and their dependencies


  @install-success
  Scenario: Install a plugin without dependencies
    Given Jenkins is installed
    And I have catalog meta-data
    When I run `jpm install ansicolor`
    Then the exit status should be 0
    And the output should contain:
      """
      Loading plugin repository data...

      Installing ansicolor v0.3.1 ...

      AnsiColor Plugin v0.3.1 will be loaded on the next restart of Jenkins!
      """


  Scenario: Install multiple plugins in one command


  Scenario: Install a plugin with dependencies


  @errorcase
  Scenario: Attempt to install a plugin while offline
    Given Jenkins is installed
    When I run `jpm install --offline ansicolor`
    Then the exit status should be 1
    And the output should contain:
      """
      This command cannot be run offline
      """

  @errorcase
  Scenario: Attempt to install a plugin that doesn't exist
    Given Jenkins is installed
    And I have catalog meta-data
    When I run `jpm install unicornsandmagic`
    Then the exit status should be 1
    And the output should contain:
      """
      Loading plugin repository data...

      `unicornsandmagic` is not a plugin I'm familiar with!

      Use `jpm search TERM` to find the correct plugin name
      """

  @errorcase
  Scenario: Attempt to install a plugin without Jenkins
    Given Jenkins isn't installed
    When I run `jpm install ansicolor`
    Then the exit status should be 1
    And the output should contain:
      """
      Jenkins is not installed!
      """
