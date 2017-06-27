Feature: Textractor CLI

  Scenario: App just runs
    When I get help for "textractor-cli"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
    And the banner should document that this app takes no arguments

  Scenario: Simple case
    Given a file named "app/views/foo/index.html.erb" with:
    """
    Hello World
    """
    And pry
    And I run `textractor-cli`
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    t(".hello_world")
    """

