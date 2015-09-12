# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/rotten/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-rotten"
  spec.version       = Rspec::Rotten::VERSION
  spec.authors       = ["Simon Bagreev"]
  spec.email         = ["sbagreev@gmail.com"]
  spec.summary       = %q{Detects rotten specs}
  spec.description   = %q{Tracks the specs that haven't changed status
                        (failed/passed/pending) for given period of time, and
                        signals you to remove them}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
