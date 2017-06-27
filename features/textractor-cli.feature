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
    And a file named "app/views/foo/show.html.erb" with:
    """
    Hello Foo
    """
    And a file named "config/locales/en.yml" with:
    """
    ---
      en:
    """
    And the endpoint "/textract" returns this content:
    """json
    {
      "app/views/foo/index.html.erb": { 
        "result": "t('hello_world')", 
        "locale": { "hello_world": "Hello World" } 
      },
      "app/views/foo/show.html.erb": { 
        "result": "t('hello_foo')", 
        "locale": { "hello_foo": "Hello Foo" }
      }
    }
    """
    And I run `textractor-cli`
    #Then the output should contain "sdf"
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "app/views/foo/index.html.erb": "Hello World",
      "app/views/foo/show.html.erb": "Hello Foo"
    }
    """
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    t('hello_world')
    """
    Then the file "app/views/foo/show.html.erb" should contain:
    """
    t('hello_foo')
    """
    Then the file "config/locales/en.yml" should contain:
    """yaml
    ---
    en:
      foo:
        index:
          hello_world: Hello World
        show:
          hello_foo: Hello Foo
    """


