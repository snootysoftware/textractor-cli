Feature: Textractor CLI

  Background:
    Given I set the environment variables to:
      | variable      | value                 |
      | API_BASE_URL  | http://localhost:8000 |
    And a file named ".textractor.rc" with:
    """
    ---
    license-key: foo
    """


  Scenario: App just runs
    When I get help for "textractor"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version| --template-pattern | --locale-path | --dry-run |
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
        "textract_calls": 1,
        "locale": { "hello_world": "Hello World" }
      }
    }
    """
    And the endpoint "/textract" returns this content:
    """json
    {
      "app/views/foo/show.html.erb": {
        "result": "t('.hello_foo')",
        "textract_calls": 1,
        "locale": { "hello_foo": "Hello Foo" }
      }
    }
    """
    And I run `textractor`
    Then the output should contain:
    """
    Processing...

    Processed 2 templates in total.
    Total errors: 0
    Total amount of string literals prepared for translation: 2
    """
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "template": "Hello World",
      "name": "app/views/foo/index.html.erb"
    }
    """
    Then the following request body should have been sent:
    """json
    {
      "template": "Hello Foo",
      "name": "app/views/foo/show.html.erb"
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
    Scenario: Display errors
    Given a file named "app/views/foo/index.html.erb" with:
    """
    <h1><h1><h1><h1>Hello World
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
       "error": "Oops, unable to infer a valid HTML5 structure. Please contact us at info@snootysoftware.com"
      }
    }
    """
    And the endpoint "/textract" returns this content:
    """json
    {
      "app/views/foo/show.html.erb": {
        "result": "t('.hello_foo')",
        "textract_calls": 1,
        "locale": { "hello_foo": "Hello Foo" }
      }
    }
    """
    And I run `textractor`
    Then the output should contain:
    """
    Processing...

     Error processing "app/views/foo/index.html.erb": Oops, unable to infer a valid HTML5 structure. Please contact us at info@snootysoftware.com

    Processed 2 templates in total.
    Total errors: 1
    Total amount of string literals prepared for translation: 1
    """
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "template": "<h1><h1><h1><h1>Hello World",
      "name": "app/views/foo/index.html.erb"
    }
    """
    Then the following request body should have been sent:
    """json
    {
      "template": "Hello Foo",
      "name": "app/views/foo/show.html.erb"
    }
    """
    Then the file "app/views/foo/index.html.erb" should contain:
    """
    <h1><h1><h1><h1>Hello World
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
        show:
          hello_foo: Hello Foo
    """
    Scenario: Dry run
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
      And the endpoint "/quote" returns this content:
      """json
      {
        "textract_calls": 1,
        "current_credits": 1000
      }
      """
      And I run `textractor --dry-run`
      Then the output should contain:
      """
      Amount of templates to be processed: 2
      Amount of t() calls: 2
      Current credits: 1000
      Credits after textract: 998
      """
      And the stderr should not contain anything
      Then the following request body should have been sent:
      """json
      {
        "template": "Hello World",
        "name": "app/views/foo/index.html.erb"
      }
      """
      Then the following request body should have been sent:
      """json
      {
        "template": "Hello Foo",
        "name": "app/views/foo/show.html.erb"
      }
      """
      Then the file "app/views/foo/index.html.erb" should contain:
      """
      Hello World
      """
      Then the file "app/views/foo/show.html.erb" should contain:
      """
      Hello Foo
      """
      Then the file "config/locales/en.yml" should contain:
      """yaml
      ---
        en:
          bar: foo
          foo:
            index:
              foo: Foo
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
        "textract_calls": 1,
        "locale": { "hello_world": "Hello World" }
      }
    }
    """
    And I run `textractor --absolute-keys`
    #Then the output should contain "sdf"
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "template": "Hello World",
      "name": "app/views/foo/index.html.erb",
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
        "textract_calls": 1,
        "locale": { "hello_world": "Hello World" }
      }
    }
    """
    And I run `textractor --templates-path views --template-pattern **/*.erb --locale locales/en.yml`
    # Then the output should contain "sdf"
    And the stderr should not contain anything
    Then the following request body should have been sent:
    """json
    {
      "template": "Hello World",
      "name": "views/index.erb"
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


