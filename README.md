## Textractor CLI

Command-line client for the Textractor service that automatically prepares ERB templates for internationalization. See https://textractor.snootysoftware.com for more information.

### Step 1. Install our open source client

It's as simple as running:

`gem install textractor-cli`

### Step 2. Configure your license key

Create a file `.textractor.rc` in your home directory, with the following content:

```
  ---
  license-key: foo
    
```

Replace "foo" with your license key.

### Step 3. Extract string literals!

To extract literals, run the following in your Rails project root:

`textractor`

This will convert your files to their translation-ready versions and add the original strings to your locale/en.yml file. To be safe, make sure to commit them to version control first.

By default, textractor will create Rails-compatible `t('.foo')` calls and add the string literals using the Rails standard structure. You can override these settings using command-line arguments. Scroll down for more information.

### Example


```
      $ cd myrailsproject
      $ cat app/views/foo/index.html.erb
      Hello World

      $ cat config/locales/en.yml
      ---
      en:

      $ textractor
      Processing...

      Processed 1 templates in total.
      Total errors: 0
      Total amount of string literals prepared for translation: 1

      $ cat app/views/foo/index.html.erb
      t('.hello_world')

      $ cat config/locales/en.yml
      ---
      en:
        foo:
          index:
            hello_world: Hello World
```

### More options

`textractor --dry-run` can be used to find out how many credits your project requires.

`textractor --template-pattern` can be used to set the Dir.glob which determines which ERB files will be processed. Our default pattern is made for Rails projects: `app/views/**/*.html.erb`

`textractor --locale-path` determines which locale file will be updated with the original strings. The default is the English language for Rails: `config/locales/en.yml`

`textractor --absolute-keys` forces the keys in `t()` calls to be absolute: `t('foo.index.hello_world')` instead of `t('.hello_world')`
