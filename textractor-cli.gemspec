# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textractor/cli/version'

Gem::Specification.new do |spec|
  spec.name          = "textractor-cli"
  spec.license       = ""
  spec.version       = Textractor::Cli::VERSION
  spec.authors       = ["Lucas & Joachim"]
  spec.email         = ["info@snootysoftware.com"]

  spec.summary       = %q{Command line tool for the Textractor service.}
  spec.homepage      = "https://github.com/snootysoftware/textractor-cli"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["textractor"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('pry-remote')
  spec.add_dependency('rest-client')
  spec.add_dependency('methadone', '~> 1.9.5')
  spec.add_development_dependency('test-unit')
end
