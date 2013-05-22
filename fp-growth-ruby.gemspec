# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fp-growth/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "fp-growth-ruby"
  spec.version       = FpGrowth::VERSION
  spec.authors       = ["thedamfr"]
  spec.email         = ["dam.cavailles@laposte.net"]
  spec.description   = %q{FP-Growth implementation}
  spec.summary       = %q{FP-Growth is mean to detect}
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
