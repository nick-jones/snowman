# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snowman/version'

Gem::Specification.new do |spec|
  spec.name          = "snowman"
  spec.version       = Snowman::VERSION
  spec.authors       = ["Nicholas Jones"]
  spec.email         = ["me@nicholasjon.es"]
  spec.summary       = "A basic UTF-8 character encoding visualiser"
  spec.homepage      = "https://github.com/nick-jones/snowman"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "~> 0.6.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
