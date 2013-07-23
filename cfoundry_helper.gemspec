# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfoundry_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "cfoundry_helper"
  spec.version       = CFoundryHelper::VERSION
  spec.authors       = ["Julian Weber"]
  spec.email         = ["jweber@anynines.com"]
  spec.description   = %q{This gem provides additional helper classes and scripts for the cfoundry gem.}
  spec.summary       = %q{This gem provides additional helper classes and scripts for the cfoundry gem.}
  spec.homepage      = "http://www.anynines.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  # cf integration-test-support dependencies
  spec.add_development_dependency "nats"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cf-uaa-lib"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "httpclient"
  spec.add_development_dependency "yajl-ruby"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-debugger"

  spec.add_dependency "cfoundry"

end