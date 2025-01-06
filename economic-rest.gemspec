lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "economic/rest/version"

Gem::Specification.new do |spec|
  spec.name = "economic-rest"
  spec.version = Economic::Rest::VERSION
  spec.authors = ["Peter Klogborg"]
  spec.email = ["klogborg@traels.it"]

  spec.summary = 'Ruby wrapper for the e-conomic REST API, that aims at making working with the API bearable.
E-conomic is a web-based accounting system. For their marketing speak, see http://www.e-conomic.co.uk/about/. More details about their API at http://www.e-conomic.co.uk/integration/integration-partner/.
The documentation can be found at https://restdocs.e-conomic.com'
  spec.homepage = "https://github.com/traels-it/economic-rest"
  spec.license = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "m"
  spec.add_development_dependency "minitest", "~> 5.25"
  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "webmock", "~> 3.24"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "coveralls"

  spec.add_dependency "rest-client", "~> 2.1"
  spec.add_dependency "activesupport", "~> 8.0"
end
