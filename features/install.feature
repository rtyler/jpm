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

  @install-success
  Scenario: Install multiple plugins in one command
    Given Jenkins is installed
    And I have catalog meta-data
    When I run `jpm install ansicolor greenballs`
    Then the exit status should be 0
    And the output should contain:
      """
      Loading plugin repository data...

      Installing ansicolor v0.3.1 ...
      Installing greenballs v1.13 ...

      AnsiColor Plugin v0.3.1, Green Balls v1.13 will be loaded on the next restart of Jenkins!
      """


  @install-success
  Scenario: Install a plugin with dependencies
    Given Jenkins is installed
    And I have catalog meta-data
    When I run `jpm install git-client`
    Then the exit status should be 0
    And the output should contain:
      """
      Loading plugin repository data...

      Installing credentials v1.9.4 ...
      Installing ssh-credentials v1.6 ...
      Installing git-client v1.6.1 ...

      Credentials Plugin v1.9.4, SSH Credentials Plugin v1.6, Git Client Plugin v1.6.1 will be loaded on the next restart of Jenkins!
      """


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
