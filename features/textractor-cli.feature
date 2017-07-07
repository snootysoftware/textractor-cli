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
      |--version| --template-pattern | --locale-path |
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
        bar: foo
        foo:
          index:
            foo: Foo
    """
    And the endpoint "/textract" returns this content:
    """json
    {
      "app/views/foo/index.html.erb": { 
        "result": "t('.hello_world')", 
        "locale": { "hello_world": "Hello World" } 
      },
      "app/views/foo/show.html.erb": { 
        "result": "t('.hello_foo')", 
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
      "templates": {
        "app/views/foo/index.html.erb": {"content": "Hello World"},
        "app/views/foo/show.html.erb": {"content": "Hello Foo"}
      }
    }
    """
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    t('.hello_world')
    """
    Then the file "app/views/foo/show.html.erb" should contain:
    """
    t('.hello_foo')
    """
    Then the file "config/locales/en.yml" should contain:
    """yaml
    ---
    en:
      bar: foo
      foo:
        index:
          foo: Foo
          hello_world: Hello World
        show:
          hello_foo: Hello Foo
    """

  Scenario: use absolute translation keys
    Given a file named "app/views/foo/index.html.erb" with:
    """
    Hello World
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
        "result": "t('foo.index.hello_world')", 
        "locale": { "hello_world": "Hello World" } 
      }
    }
    """
    And I run `textractor-cli --absolute-keys`
    #Then the output should contain "sdf"
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "templates": {
        "app/views/foo/index.html.erb": {"content": "Hello World"}
      },
      "absolute_keys": true
    }
    """
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    t('foo.index.hello_world')
    """
    Then the file "config/locales/en.yml" should contain:
    """yaml
    ---
    en:
      foo:
        index:
          hello_world: Hello World
    """



  Scenario: Override default locale and template pattern settings
    Given a file named "views/index.erb" with:
    """
    Hello World
    """
    And a file named "locales/en.yml" with:
    """
    ---
      en:
    """
    And the endpoint "/textract" returns this content:
    """json
    {
      "views/index.erb": { 
        "result": "t('.hello_world')", 
        "locale": { "hello_world": "Hello World" } 
      }
    }
    """
    And I run `textractor-cli --templates-path views --template-pattern **/*.erb --locale locales/en.yml`
    #Then the output should contain "sdf"
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "templates": {
        "views/index.erb": {"content": "Hello World"}
      }
    }
    """
    Then the file "views/index.erb" should contain:
    """
    t('.hello_world')
    """
    Then the file "locales/en.yml" should contain:
    """yaml
    ---
    en:
      index:
        hello_world: Hello World
    """


