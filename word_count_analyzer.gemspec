# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'word_count_analyzer/version'

Gem::Specification.new do |spec|
  spec.name          = "word_count_analyzer"
  spec.version       = WordCountAnalyzer::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]
  spec.summary       = %q{A word count analyzer - see what word count gray areas might be affecting your word count.}
  spec.description   = %q{Word Count Analyzer is a Ruby gem that analyzes a string for potential areas of the text that might cause word count discrepancies depending on the tool used. It also provides comprehensive configuration options so you can easily customize how different gray areas should be counted and find the right word count for your purposes.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "engtagger"
end
