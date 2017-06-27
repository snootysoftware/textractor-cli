Feature: Textractor CLI

  Background:
    Given I set the environment variables to:
      | variable      | value                 |
      | API_BASE_URL  | http://localhost:8000 |

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
    And the endpoint "/textract" returns this content:
    """
    t('hello_world')
    """
    And I run `textractor-cli`
    #Then the output should contain "sdf"
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    t('hello_world')
    """

